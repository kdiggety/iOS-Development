//
//  KeyboardNote.swift
//  the MC
//
//  Created by Lewis, Kenneth on 6/13/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import QuartzCore
import UIKit

class KeyboardNote: UIControl {

    let defBgColor : UIColor = UIColor.redColor()
    let defHlColor : UIColor = UIColor.greenColor()
    
    //let topLayer = CALayer()
    //let thumbLayer = CALayer()
    var previousLocation = CGPoint()

    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    var minimumValue = 0.0
    var maximumValue = 1.0
    var lowerValue = 0.2
    var upperValue = 0.8
    
    override init(frame: CGRect) {
        println("KeyboardNote.init")
        super.init(frame: frame)
        
        self.backgroundColor = defBgColor
        
        //topLayer.backgroundColor = UIColor.blackColor().CGColor
        //layer.addSublayer(topLayer)
        
        //thumbLayer.backgroundColor = UIColor.greenColor().CGColor
        //layer.addSublayer(thumbLayer)
        
        self.tag = 123
        
        self.addTarget(self, action: "keepTracking:", forControlEvents: UIControlEvents.TouchDragInside)
        self.addTarget(self, action: "stopTracking:", forControlEvents: UIControlEvents.TouchUpInside)
        
        updateLayerFrames()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames() {
        println("KeyboardNote.updateLayerFrames")
        
        //topLayer.frame = bounds.rectByInsetting(dx: 0.0, dy: bounds.height / 2)
        //topLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        
        //thumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
            //width: thumbWidth, height: thumbWidth)
        //thumbLayer.setNeedsDisplay()
    }
    
    func positionForValue(value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        println("KeyboardNote.beginTrackingWithTouch")
        
        self.backgroundColor = defHlColor
        
        previousLocation = touch.locationInView(self)
        
        // Hit test the thumb layers
        /*if topLayer.frame.contains(previousLocation) {
            highlighted = true
            topLayer.borderColor = UIColor.cyanColor().CGColor
        }*/
        
        highlighted = true
        
        return highlighted
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        println("KeyboardNote.continueTrackingWithTouch")
        
        highlighted = true
        
        return highlighted
    }

    override func cancelTrackingWithEvent(event: UIEvent?) {
        println("KeyboardNote.cancelTrackingWithEvent")
        
        self.backgroundColor = defBgColor
        
        if touchInside {
            highlighted = true
        } else {
            highlighted = false
        }
        
        println("KeyboardNote.cancelTrackingWithEvent - touchInside=\(touchInside)")
    }

    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        println("KeyboardNote.endTrackingWithTouch")
        
        self.backgroundColor = defBgColor
        
        highlighted = false
        //topLayer.borderColor = UIColor.blackColor().CGColor
    }
    
    func keepTracking(sender: UIControl) {
        println("KeyboardNote.keepTracking")
    }
    
    func stopTracking(sender: UIControl) {
        println("KeyboardNote.stopTracking")
    }
}
