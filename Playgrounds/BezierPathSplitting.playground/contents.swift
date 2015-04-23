// Playground - noun: a place where people can play

import Foundation
import SwiftGraphics
import SwiftGraphicsPlayground

let points = [
    CGPoint(x:120,y:160),
    CGPoint(x:35,y:200),
    CGPoint(x:220,y:260),
    CGPoint(x:220,y:40),
]

func drawCurve(context:CGContext, curve:BezierCurve, point:(BezierCurve,CGFloat) -> CGPoint) {
    // Draw the whole bezier curve in green
    context.strokeColor = CGColor.blackColor().withAlpha(0.5)

    context.stroke(curve)

    // Get points along the curve and plot them
    var newPoints:[CGPoint] = map(stride(from: 0.0, through: 1.0, by: 0.1)) {
        return point(curve, $0)
    }

    context.strokeColor = CGColor.blueColor()
    context.plotPoints(newPoints)
}

let cgimage = CGContextRef.imageWithBlock(CGSize(w:500, h:250), color:CGColor.lightGrayColor(), origin:CGPointZero) {
    (context:CGContext) -> Void in

    let curve = BezierCurve(points:points)
    drawCurve(context, curve) { pointOnCurve($0, $1) }

    CGContextTranslateCTM(context, 250, 0)
    drawCurve(context, curve) { $0.pointAlongCurve($1) }
}

NSImage(CGImage: cgimage, size: cgimage.size)

