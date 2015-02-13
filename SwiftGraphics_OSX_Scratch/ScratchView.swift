//
//  ScratchView.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/25/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

class ScratchView: NSView {

    var model:Model! {
        didSet {
            model.addObserver(self, forKeyPath: "objects", options: NSKeyValueObservingOptions(), context: nil)
            dragging = Dragging(model:model)
            dragging.view = self
        }
    }
    var dragging:Dragging!
    var renderer:Renderer!

    required init?(coder: NSCoder) {
        super.init(coder:coder)
        wantsLayer = true
        renderer = DrawableRenderer()
    }

    override var acceptsFirstResponder:Bool {
        get {
            return true
        }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let context = NSGraphicsContext.currentContext()!.CGContext

        for (index, thing) in enumerate(model.objects) {
            let localTransform = CGAffineTransform(translation: thing.frame.origin)
            context.with(localTransform) {
                if model.selectedObjectIndices.containsIndex(index) {
                    dragging.draw(context, object:thing)
                }
                else {
                    renderer.draw(context, object:thing)
                }
            }
        }

        gestureDebugger.drawInContext(context)
    }

    var gestureDebugger = GestureDebugger()

    override func addGestureRecognizer(gestureRecognizer: NSGestureRecognizer) {
        super.addGestureRecognizer(gestureRecognizer)
        gestureDebugger.addGestureRecognizer(gestureRecognizer)
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        // Yup, this is super lazy
        self.needsDisplay = true
    }

}

