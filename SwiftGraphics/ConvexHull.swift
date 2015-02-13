//
//  ConvexHull.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public func convexHull(var points:[CGPoint], sorted:Bool = false) -> [CGPoint] {
    return monotoneChain(points, sorted:sorted)
}

struct ConvexHull {
    var points:[CGPoint] {
        didSet {
            cachedPolygon = nil
        }
    }
    var polygon:Polygon {
        mutating get {
            if cachedPolygon == nil {
                let polygonPoints = convexHull(points, sorted: false)
                cachedPolygon = Polygon(points: polygonPoints)
            }
            return cachedPolygon!
        }
    }
    var cachedPolygon:Polygon?


}