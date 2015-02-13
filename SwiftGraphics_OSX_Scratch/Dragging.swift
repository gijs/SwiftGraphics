//
//  Dragging.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/3/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

public protocol Draggable {
    var position:CGPoint { get set }
}

class Dragging: Renderer {

    var model:Model!
    var panGestureRecognizer:NSPanGestureRecognizer!
    var draggedObject:Draggable? = nil
    var dragBeganLocation:CGPoint?
    var offset:CGPoint = CGPointZero
    var selectionMarquee:SelectionMarquee = SelectionMarquee()

    init(model:Model) {
        self.model = model
        panGestureRecognizer = NSPanGestureRecognizer(callback:nil)
        panGestureRecognizer.addCallback() {
            [unowned self] in
            self.pan(self.panGestureRecognizer)
        }
    }

    var view:NSView! {
        willSet {
            if let view = view {
                view.removeGestureRecognizer(panGestureRecognizer)
            }
        }
        didSet {
            if let view = view {
                view.addGestureRecognizer(panGestureRecognizer)
            }
        }
    }

    func pan(gestureRecognizer:NSPanGestureRecognizer) {
        switch gestureRecognizer.state {
            case .Began:
                panBegun(gestureRecognizer)
            case .Changed:
                panChanged(gestureRecognizer)
            case .Ended:
                panEnded(gestureRecognizer)
            default:
                break
        }
    }

    func panBegun(gestureRecognizer:NSPanGestureRecognizer) {
        dragBeganLocation = gestureRecognizer.locationInView(view)
        draggedObject = hitTest(dragBeganLocation!)
        if let draggedObject = draggedObject {
            if let thing = draggedObject as? Thing {
                unselectAll()
                selectObject(thing)
            }
            offset = dragBeganLocation! - draggedObject.position
        }
        else {
            selectionMarquee.active = true
            selectionMarquee.panLocation = dragBeganLocation!
            view.layer!.addSublayer(selectionMarquee.layer)
        }
        needsDisplay = true
    }

    func panChanged(gestureRecognizer:NSPanGestureRecognizer) {
        let location = gestureRecognizer.locationInView(view)
        if draggedObject != nil {
            draggedObject!.position = location - offset
            if let handle = draggedObject as? Handle {
//                handle.owner.handleChanged(handle)
            }
        }
        else {
            selectionMarquee.panLocation = location
            for thing in model.objects {
                var selected = thing.intersects(selectionMarquee.cgpath)
                if selected {
                    selectObject(thing)
                }
                else {
                    unselectObject(thing)
                }
            }
        }
        needsDisplay = true
    }

    func panEnded(gestureRecognizer:NSPanGestureRecognizer) {
        draggedObject = nil
        offset = CGPointZero
        selectionMarquee.active = false
        selectionMarquee.layer.removeFromSuperlayer()
        needsDisplay = true
    }

    func selectObject(object:Draggable) {
        if let thing = object as? Thing {
            model.selectObject(thing)
        }
    }

    func unselectObject(object:Draggable) {
        if let thing = object as? Thing {
            model.unselectObject(thing)
        }
    }

    func unselectAll() {
        model.selectedObjectIndices.removeAllIndexes()
    }

    func hitTest(location:CGPoint) -> Draggable? {
        var hit = model.hitTest(location)?.1
        if let hit = hit {
            return hit
        }

        for object in model.selectedObjects {
            for handle in object.handles {
                if CGRect(center: handle.position, radius:3).contains(location - object.frame.origin) {
                    return handle
                }
            }
        }

        return nil
    }

    var needsDisplay:Bool {
        get {
            return view.needsDisplay
        }
        set {
            view.needsDisplay = newValue
        }
    }

    func draw(context:CGContext, object:Any) {
        if let thing = object as? Thing {
            context.lineWidth = 2.0
            context.strokeColor = CGColor.blueColor()
            thing.geometry.drawInContext(context)

            for handle in thing.handles {
                context.fillCircle(center: handle.position, radius: 3)
            }
        }
    }
}

