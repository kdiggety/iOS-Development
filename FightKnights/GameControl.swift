//
//  GameControls.swift
//  FightKnights
//
//  Created by Lewis, Kenneth on 5/11/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import SpriteKit

@objc protocol GameControlProtocol {
    func moveGameControl(gameControl: GameControl, velocity: CGPoint, angularVelocity: Float)
}

class GameControl: SKNode {
    var velocityLoop: CADisplayLink?
    let thumbNode: SKSpriteNode, bgNode: SKSpriteNode
    
    let kThumbSpringBackDuration: NSTimeInterval = 0.15 // action duration
    var isTracking = false
    var velocity = CGPointZero, anchorPointInPoints = CGPointZero
    var angularVelocity = Float()

    func setThumbImage(image: UIImage?, sizeToFit: Bool) {
        println("GameControl.setThumbImage")
        var tImage: UIImage = image != nil ? image! : UIImage(named: "aSThumbImg")!
        self.thumbNode.texture = SKTexture(image: tImage)
        if sizeToFit {
            self.thumbNodeDiametr = min(tImage.size.width, tImage.size.height)
        }
    }
    
    func setBgImage(image: UIImage?, sizeToFit: Bool) {
        println("GameControl.setBgImage")
        var tImage: UIImage = image != nil ? image! : UIImage(named: "aSBgImg")!
        self.bgNode.texture = SKTexture(image: tImage)
        if sizeToFit {
            self.bgNodeDiametr = min(tImage.size.width, tImage.size.height)
        }
    }
    
    var bgNodeDiametr: CGFloat {
        get { return self.bgNode.size.width }
        set { self.bgNode.size = CGSizeMake(newValue, newValue) }
    }
    
    var thumbNodeDiametr: CGFloat {
        get { return self.bgNode.size.width }
        set { self.thumbNode.size = CGSizeMake(newValue, newValue) }
    }
    
    var delagate: GameControlProtocol? {
        didSet {
            velocityLoop?.invalidate()
            velocityLoop = nil
            if delagate != nil {
                velocityLoop = CADisplayLink(target: self, selector: Selector("update"))
                velocityLoop?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
            }
        }
    }
    
    func update() {
        if isTracking {
            delagate?.moveGameControl(self, velocity: self.velocity, angularVelocity: self.angularVelocity)
        }
    }

    
    convenience override init() {
        self.init(thumbImage: nil, bgImage: nil)
    }
    
    convenience init(thumbImage: UIImage?) {
        self.init(thumbImage: thumbImage, bgImage: nil)
    }
    
    convenience init(bgImage: UIImage?) {
        self.init(thumbImage: nil, bgImage: bgImage)
    }
    
    init(thumbImage: UIImage?, bgImage: UIImage?) {
        println("GameControl.init(..., ...)")
        self.thumbNode = SKSpriteNode()
        self.bgNode = SKSpriteNode()
        super.init()
        setThumbImage(thumbImage, sizeToFit: true)
        setBgImage(bgImage, sizeToFit: true)
        self.userInteractionEnabled = true;
        self.isTracking = false
        self.velocity = CGPointZero
        self.addChild(bgNode) // first bg
        self.addChild(thumbNode) // after thumb
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // touch begin
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        println("GameControl.touchesBegan")
        
        for touch: AnyObject in touches {
            let location: CGPoint = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            if self.thumbNode == touchedNode && isTracking == false {
                isTracking = true
            }
        }
    }
}