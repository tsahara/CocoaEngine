//
//  AppDelegate.swift
//  CocoaEngine
//
//  Created by Tomoyuki Sahara on 8/22/15.
//  Copyright (c) 2015 Tomoyuki Sahara. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var canvas: EngineView!

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        canvas.needsDisplay = true
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("timer:"), userInfo: nil, repeats: true)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    func timer(sender: NSTimer) {
        canvas.needsDisplay = true
    }
}

class EngineView : NSView {
    var tick = 0

    override func drawRect(dirtyRect: NSRect) {
//        tick = 0
        let r = CGFloat(50.0)
        let speed = 16
        
        NSColor.blackColor().setFill()
        NSRectFill(self.bounds)
        
        let cx = r * 4
        let cy = r * 2
        
        // crankcase
        let x1 = cx - r / 2
        let x2 = cx + r / 2
        let y1 = cy + r * 3
        let y2 = cy + sqrt(3.0) / 2 * r
        NSColor.redColor().setStroke()
        var path = NSBezierPath()
        path.lineWidth = 4.0
        path.moveToPoint(NSPoint(x: x1, y:y2))
        path.lineToPoint(NSPoint(x: x1, y:y1))
        path.lineToPoint(NSPoint(x: x2, y:y1))
        path.lineToPoint(NSPoint(x: x2, y:y2))
        path.appendBezierPathWithArcWithCenter(NSPoint(x: cx, y: cy), radius: r, startAngle: 60, endAngle: 120, clockwise: true)
        path.stroke()
        
        // cooling fins
        path.removeAllPoints()
        path.lineWidth = 6.0
        let l2 = r / 2
        for i in 0..<3 {
            let y = y1 - r/2 - r/3*CGFloat(i)
            path.moveToPoint(NSPoint(x: x1, y:y))
            path.lineToPoint(NSPoint(x: x1 - l2, y:y))
            path.moveToPoint(NSPoint(x: x2, y:y))
            path.lineToPoint(NSPoint(x: x2 + l2, y:y))
        }
        path.stroke()

        // arc of crankshaft
        let ra = r*0.7
        let p1 = (CGFloat(tick) / CGFloat(speed) - 1.0/7)
        let p2 = (CGFloat(tick) / CGFloat(speed) + 1.0/7)
        let x3 = cx + ra * cos(p1 * CGFloat(2.0*M_PI))
        let y3 = cy + ra * sin(p1 * CGFloat(2.0*M_PI))
        let x4 = cx + ra * cos(p2 * CGFloat(2.0*M_PI))
        let y4 = cy + ra * sin(p2 * CGFloat(2.0*M_PI))

        NSColor(calibratedHue: 0.4, saturation: 1, brightness: 0.5, alpha: 1).setFill()
        path.removeAllPoints()
        path.lineWidth = 4.0
        path.moveToPoint(NSPoint(x:cx, y:cy))
        path.lineToPoint(NSPoint(x:x3, y:y3))
        path.appendBezierPathWithArcWithCenter(NSPoint(x: cx, y: cy), radius: ra, startAngle: p1*360.0, endAngle: p2*360.0)
        path.lineToPoint(NSPoint(x:x4, y:y4))

        path.fill()

        // connecting rod
        let rb = r*0.5
        var angle = 2.0*M_PI * Double(tick + speed/2) / Double(speed)
        let x5 = cx + rb * CGFloat(cos(angle))
        let y5 = cy + rb * CGFloat(sin(angle))
        let yp = cy + sqrt(pow(r*2, 2.0) - pow(rb/2 * CGFloat(cos(angle)), 2.0)) + rb * CGFloat(sin(angle))
        
        NSColor.cyanColor().setStroke()
        path.lineJoinStyle = NSLineJoinStyle.RoundLineJoinStyle
        path.removeAllPoints()
        path.moveToPoint(NSPoint(x:cx, y:cy))
        path.lineToPoint(NSPoint(x:x5, y:y5))
        path.lineToPoint(NSPoint(x:cx, y:yp))
        path.stroke()
        
        // shaft of
        NSColor.grayColor().setFill()
        path.removeAllPoints()
        path.appendBezierPathWithArcWithCenter(NSPoint(x: cx, y: cy), radius: r/6, startAngle: 0, endAngle: 360)
        path.fill()
        
        // piston
        path.removeAllPoints()
        path.appendBezierPathWithRect(NSRect(x: cx - r*3/7, y: yp - r*1/3, width: r*6/7, height: r*2/3))
        path.fill()
        
        NSColor.cyanColor().setFill()
        path.removeAllPoints()
        path.appendBezierPathWithArcWithCenter(NSPoint(x: cx, y: yp), radius: r/12, startAngle: 0, endAngle: 360)
        path.fill()
        
        NSColor.cyanColor().setStroke()
        path.removeAllPoints()
        path.lineWidth = 2.0
        path.moveToPoint(NSPoint(x: cx - r*3/7, y: yp + r*4/15))
        path.relativeLineToPoint(NSPoint(x: r*6/7, y: 0))
        path.stroke()
        
        // connecting rod
        
        self.tick++
    }
}
