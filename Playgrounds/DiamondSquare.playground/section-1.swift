

import SwiftGraphics
import SwiftGraphicsPlayground

func squareDiamond(inout grid:Grid_Array <CGFloat>, rect:IntRect, f:Void -> CGFloat) {

//    if rect.size.width < 3 || rect.size.height < 3 {
//        return
//    }

    let minX:Int = rect.origin.x
    let maxX:Int = rect.origin.x + rect.size.width - 1
    let midX:Int = (minX + maxX) / 2

    let minY:Int = rect.origin.y
    let maxY:Int = rect.origin.y + rect.size.height - 1
    let midY:Int = (minY + maxY) / 2

    g[midX, minY] = (g[minX, minY] + g[maxX, minY]) / 2
    g[midX, maxY] = (g[minX, maxY] + g[maxX, maxY]) / 2
    g[minX, midY] = (g[minX, minY] + g[minX, maxY]) / 2
    g[maxX, midY] = (g[maxX, minY] + g[maxX, maxY]) / 2

    g[midX, midY] = (g[midX, minY] + g[midX, maxY] + g[minX, midY] + g[maxX, midY]) / 4.0 + f()

    let halfSize = IntSize(
        width:rect.size.width / 2 + 1,
        height:rect.size.height / 2 + 1
    )

    if halfSize.width < 3 || halfSize.height < 3 {
        return
    }

    squareDiamond(&grid, IntRect(origin:IntPoint(x:minX, y:minY), size: halfSize), f)
    squareDiamond(&grid, IntRect(origin:IntPoint(x:minX, y:midY), size: halfSize), f)
    squareDiamond(&grid, IntRect(origin:IntPoint(x:midX, y:minY), size: halfSize), f)
    squareDiamond(&grid, IntRect(origin:IntPoint(x:midX, y:midY), size: halfSize), f)
}

var g = Grid_Array <CGFloat> (width:9, height:9, defaultValue:0.5)

//g[0, 0] = 0.5; g[8, 0] = 0.5
//g[0, 8] = 0.5; g[8, 8] = 0.5

let rect = IntRect(origin:IntPoint(x:0, y:0), size: g.size)
squareDiamond(&g, rect) {
    return Random.rng.random() * 0.5
}


//struct Channel <T:Comparable> {
//    let width:Int
//    let height:Int
//    let range:ClosedInterval <T>
//    let data:UnsafeBufferPointer <T>
//
//    init(width:Int, height:Int, range:ClosedInterval <T>, buffer:UnsafeBufferPointer <T>) {
//        self.width = width
//        self.height = height
//        self.range = range
//        self.data = buffer
//    }
//}
//
//struct Bitmap <T> {
//    let width:Int
//    let height:Int
//    var data:UnsafePointer <T>?
//
//    init(width:Int, height:Int) {
//        self.width = width
//        self.height = height
//    }
//
//    func addChannel <U> (channel:Channel <U>, component:String) {
//
//
//        let normalized:[U] = channel.data.map() {
//            return $0
//
//        }
//
//
//    }
//}
//
//let bitmap = Bitmap <UInt32> (width:g.size.width, height:g.size.height)
//
//let channel = Channel <CGFloat> (width:g.size.width, height:g.size.height, range:0...1.0, buffer: g.buffer)
//bitmap.addChannel(channel, component:"green")


var pixels:[UInt32] = g.buffer.map() {
    (value:CGFloat) -> UInt32 in

    let value = clamp(value, 0, 1.0)

    let g = UInt32(value * 255)


    return 0x000000FF | g << 16
}

pixels.withUnsafeMutableBufferPointer() {
    (inout buffer:UnsafeMutableBufferPointer <UInt32>) -> Void in

    let colorspace = CGColorSpaceCreateDeviceRGB()
    var bitmapInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedFirst.rawValue)

    let bitmapContext = CGBitmapContextCreate(UnsafeMutablePointer <Void> (buffer.baseAddress), UInt(g.size.width), UInt(g.size.height), 8, 4 * UInt(g.size.width), colorspace, bitmapInfo)

    let cgImage = CGBitmapContextCreateImage(bitmapContext)
    let image = NSImage(CGImage:cgImage, size:CGSize(width:CGFloat(g.size.width), height:CGFloat(g.size.height)))
    image

}













