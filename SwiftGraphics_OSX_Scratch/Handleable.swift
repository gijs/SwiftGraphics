//
//  Handleable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/11/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

public protocol Handleable {
    var handles:[Handle] { get }
    mutating func handleUpdated(handle:Handle)
}

public class Handle: Draggable {
    public var name:String
    public var position:CGPoint
    public var userInfo:Any?
    public var updated:(Void -> Void)? = nil

    init(name:String, position:CGPoint, userInfo:Any? = nil) {
        self.name = name
        self.position = position
        self.userInfo = userInfo
    }
}

// MARK: -

extension Rectangle: Handleable {
    public var handles:[Handle] {
        get {
            let handles:[Handle] = RectanglePoint.allValues.map() {
                var handle = Handle(name:toString($0), position:$0.pointOfRectangle(self.frame), userInfo:$0)
                return handle
            }
            return handles
        }
    }

    public mutating func handleUpdated(handle:Handle) {
        let rectanglePoint:RectanglePoint = handle.userInfo as! RectanglePoint
        frame = rectanglePoint.rectWithPointOfRectangle(frame, point: handle.position)
    }
}

// MARK: -

extension Circle: Handleable {
    public var handles:[Handle] {
        get {
            return []
        }
    }
    public mutating func handleUpdated(handle:Handle) {
    }
}

// MARK: -

extension Triangle: Handleable {
    public var handles:[Handle] {
        get {
            return []
        }
    }
    public mutating func handleUpdated(handle:Handle) {
    }
}

// MARK: -

public enum RectanglePoint {
    case minXMinY
    case minXMidY
    case minXMaxY
    case midXMinY
    case midXMidY
    case midXMaxY
    case maxXMinY
    case maxXMidY
    case maxXMaxY
}

extension RectanglePoint {
    static var allValues:[RectanglePoint] {
        return [
            .minXMinY, .minXMidY, .minXMaxY,
            .midXMinY, .midXMidY, .midXMaxY,
            .maxXMinY, .maxXMidY, .maxXMaxY,
        ]
    }
}

extension RectanglePoint {
    func pointOfRectangle(rect:CGRect) -> CGPoint {
        switch self {
            case .minXMinY:
                return rect.minXMinY
            case .minXMidY:
                return rect.minXMidY
            case .minXMaxY:
                return rect.minXMaxY
            case .midXMinY:
                return rect.midXMinY
            case .midXMidY:
                return rect.midXMidY
            case .midXMaxY:
                return rect.midXMaxY
            case .maxXMinY:
                return rect.maxXMinY
            case .maxXMidY:
                return rect.maxXMidY
            case .maxXMaxY:
                return rect.maxXMaxY
        }
    }

    func rectWithPointOfRectangle(rect:CGRect, point:CGPoint) -> CGRect {
        switch self {
            case .minXMinY:
                return CGRect(points: (point, rect.maxXMaxY))
            case .minXMidY:
                return CGRect(points: (CGPoint(x:point.x, y:rect.minY), rect.maxXMaxY))
            case .minXMaxY:
                return CGRect(points: (point, rect.maxXMinY))
            case .midXMinY:
                return CGRect(points: (CGPoint(x:rect.minX, y:point.y), rect.maxXMaxY))
            case .midXMidY:
                return CGRect(center:point, size:rect.size)
            case .midXMaxY:
                return CGRect(points: (CGPoint(x:rect.minX, y:point.y), rect.maxXMinY))
            case .maxXMinY:
                return CGRect(points: (point, rect.minXMaxY))
            case .maxXMidY:
                return CGRect(points: (CGPoint(x:point.x, y:rect.minY), rect.minXMaxY))
            case .maxXMaxY:
                return CGRect(points: (point, rect.minXMinY))
        }
    }
}

//extension CGRect {
//    init(
//}

extension RectanglePoint: Printable {
    public var description:String {
        get {
            switch self {
                case .minXMinY:
                    return "minXMinY"
                case .minXMidY:
                    return "minXMidY"
                case .minXMaxY:
                    return "minXMaxY"
                case .midXMinY:
                    return "midXMinY"
                case .midXMidY:
                    return "midXMidY"
                case .midXMaxY:
                    return "midXMaxY"
                case .maxXMinY:
                    return "maxXMinY"
                case .maxXMidY:
                    return "maxXMidY"
                case .maxXMaxY:
                    return "maxXMaxY"
            }
        }
    }
}