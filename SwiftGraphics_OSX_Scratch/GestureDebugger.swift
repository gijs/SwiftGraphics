//
//  GestureDebugger.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/13/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

class GestureDebugger {

    var locations:[CGPoint] = []
    var startLocation:CGPoint?
    var currentLocation:CGPoint?

    func drawInContext(context:CGContext) {
//        context.plotPoints(locations)
        if let startLocation = startLocation, currentLocation = currentLocation {
            context.strokeColor = CGColor.redColor()
            context.lineWidth = 1.0
            context.lineDash = [10, 10]
            context.strokeLine(startLocation, currentLocation)
            context.lineDash = []
        }
    }

    func addGestureRecognizer(gestureRecognizer: NSGestureRecognizer) {
        if gestureRecognizer.isKindOfClass(NSPanGestureRecognizer.self) {
            gestureRecognizer.addCallback() {
                [unowned self] in
                let location = gestureRecognizer.locationInView(gestureRecognizer.view)

                switch gestureRecognizer.state {
                    case .Began:
                        self.startLocation = location
                        MagicLog("startLocation", location)
                    case .Changed:
                        MagicLog("location", location)
                        let delta = location - self.startLocation!
                        MagicLog("delta", location - delta)

                        let angle = atan2(delta)
//                        self.startLocation!.angleTo(location))

                        MagicLog("angle", RadiansToDegrees(angle))

                        self.currentLocation = location
                    default:
                        break
                }
                self.locations.append(location)
                gestureRecognizer.view!.needsDisplay = true
            }
        }
    }



}