//
//  Thing.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/13/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

// MARK: -

public class Thing: Frameable, Equatable {

    typealias ThingType = protocol <HitTestable, Drawable, Geometry, Markupable, Handleable, CGPathable>

    weak var model:Model?
    var geometry:ThingType

    var selected: Bool {
        get {
            return model!.objectSelected(self)
        }
    }

    init(model:Model, geometry:ThingType) {
        self.model = model
        self.geometry = geometry
        self.center = geometry.frame.mid
    }

    var bounds:CGRect { get { return geometry.frame } }

    var center:CGPoint = CGPointZero

    var frame:CGRect { get { return CGRect(center:center, size:bounds.size) } }

    var savedHandles:[Handle]? = nil
}

public func ==(lhs: Thing, rhs: Thing) -> Bool {
    // TOTO hack
    return lhs === rhs
}

extension Thing: CGPathable {
    public var cgpath:CGPath { get { return geometry.cgpath } }
}

extension Thing: Drawable {
    public func drawInContext(context:CGContextRef) {
        context.lineWidth = 1.0
        context.strokeColor = CGColor.blackColor()
        self.geometry.drawInContext(context)
    }
}

extension Thing: HitTestable {
    public func contains(point:CGPoint) -> Bool {
        let transformedPoint = point - frame.origin
        return self.geometry.contains(transformedPoint)
    }

    public func intersects(rect:CGRect) -> Bool {
        return geometry.intersects(rect.offsetBy(-frame.origin))
    }

    public func intersects(path:CGPath) -> Bool {
        var transform = CGAffineTransform(translation: -frame.origin)
        let path = CGPathCreateCopyByTransformingPath(path, &transform)
        return geometry.intersects(path)
    }
}

extension Thing: Handleable {
    public var handles:[Handle] {
        get {
            if savedHandles == nil {
                savedHandles = geometry.handles
            }
            return savedHandles!
        }
    }
    public func handleUpdated(handle:Handle) {
        geometry.handleUpdated(handle)
    }
}

extension Thing: Draggable {
    public var position:CGPoint {
        get {
            return center
        }
        set {
            center = newValue
        }
    }
}

















