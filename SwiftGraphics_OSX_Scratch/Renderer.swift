//
//  Renderer.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/13/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

import SwiftGraphics

public protocol Renderer {
    func draw(context:CGContext, object:Any)
}

struct DrawableRenderer: Renderer {
    func draw(context:CGContext, object:Any) {
        if let drawable = object as? Drawable {
            drawable.drawInContext(context)
        }
    }
}