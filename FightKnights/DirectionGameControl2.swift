//
//  DirectionGameControl2.swift
//  FightKnights
//
//  Created by Lewis, Kenneth on 5/12/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import SpriteKit

class DirectionGameControl2: GameControl2 {
    override func setThumbImage(image: UIImage?, sizeToFit: Bool) {
        var tImage: UIImage = image != nil ? image! : UIImage(named: "aSThumbImg")!
        super.setThumbImage(tImage, sizeToFit: sizeToFit);
    }
    
    override func setBgImage(image: UIImage?, sizeToFit: Bool) {
        var tImage: UIImage = image != nil ? image! : UIImage(named: "aSBgImg")!
        super.setBgImage(tImage, sizeToFit: sizeToFit);
    }
    
    // touch move
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        
        println("DirectionGameControl2.touchesMoved")
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let xDistance: Float = Float(location.x - self.thumbNode.position.x)
            let yDistance: Float = Float(location.y - self.thumbNode.position.y)
            if self.isTracking == true && sqrtf(powf(xDistance, 2) + powf(yDistance, 2)) <= Float(self.bgNodeDiametr * 2) {
                let xAnchorDistance: CGFloat = (location.x - self.anchorPointInPoints.x)
                let yAnchorDistance: CGFloat = (location.y - self.anchorPointInPoints.y)
                if sqrt(pow(xAnchorDistance, 2) + pow(yAnchorDistance, 2)) <= self.thumbNode.size.width {
                    let moveDifference: CGPoint = CGPointMake(xAnchorDistance , yAnchorDistance)
                    self.thumbNode.position = CGPointMake(self.anchorPointInPoints.x + moveDifference.x, self.anchorPointInPoints.y + moveDifference.y)
                } else {
                    let magV = sqrt(xAnchorDistance * xAnchorDistance + yAnchorDistance * yAnchorDistance)
                    let aX = self.anchorPointInPoints.x + xAnchorDistance / magV * self.thumbNode.size.width
                    let aY = self.anchorPointInPoints.y + yAnchorDistance / magV * self.thumbNode.size.width
                    self.thumbNode.position = CGPointMake(aX, aY)
                }
                let tNAnchPoinXDiff: CGFloat = self.thumbNode.position.x - self.anchorPointInPoints.x;
                let tNAnchPoinYDiff: CGFloat = self.thumbNode.position.y - self.anchorPointInPoints.y
                self.velocity = CGPointMake(tNAnchPoinXDiff, tNAnchPoinYDiff)
                self.angularVelocity = -atan2f(Float(tNAnchPoinXDiff), Float(tNAnchPoinYDiff))
            }
        }
    }
    
    // touch end
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        println("DirectionGameControl2.touchesEnded")
        reset()
    }
    
    // touch cancel
    override func touchesCancelled(touches: NSSet, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        println("DirectionGameControl2.touchesCancelled")
        reset()
    }
    
    func reset() {
        self.isTracking = false
        self.velocity = CGPointZero
        let easeOut: SKAction = SKAction.moveTo(self.anchorPointInPoints, duration: kThumbSpringBackDuration)
        easeOut.timingMode = SKActionTimingMode.EaseOut
        self.thumbNode.runAction(easeOut)
    }
}
