//
//  GameControl2.swift
//  FightKnights
//
//  Created by Lewis, Kenneth on 5/12/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

//
//  GameControls2.swift
//  FightKnights
//
//  Created by Lewis, Kenneth on 5/11/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import SpriteKit

@objc protocol GameControl2Protocol {
    func gameControlMoved(gameControl: GameControl2, velocity: CGPoint, angularVelocity: Float)
    func gameControlClicked(gameControl: GameControl2)
}

enum ControlStyle {
    case CircleOrEllipse
    case SquareOrRectangle
    case Default
}

enum ControlType {
    case Draggable
    case Clickable
    case Default
}

class GameControl2: SKNode {
    let defButtonSize: CGSize = CGSizeMake(36, 36)
    let defCornerRadius: CGFloat = 3
    let defCircleOfRadius: CGFloat = 18
    let defButtonPadding: CGFloat = 6
    
    let defButtonColor: SKColor = SKColor.blackColor()
    let defDepressButtonColor: SKColor = SKColor.blackColor()
    let defButtonBaseColor: SKColor = SKColor.grayColor()
    
    var buttonNode: SKShapeNode!, buttonBaseNode: SKShapeNode!
    
    let kThumbSpringBackDuration: NSTimeInterval = 0.15 // action duration

    var buttonSize: CGSize = CGSizeMake(36, 36)
    var buttonStyle: ControlStyle = ControlStyle.Default
    var buttonType: ControlType = ControlType.Default
    var buttonColor: SKColor, buttonDepressColor: SKColor, buttonBaseColor: SKColor
    var buttonCornerRadius: CGFloat
    var buttonPadding: CGFloat
    
    var velocityLoop: CADisplayLink?
    var isTracking = false, isClicking = false
    var velocity = CGPointZero, anchorPointInPoints = CGPointZero
    var angularVelocity = Float()
    
    func setupButtonNode() {
        println("GameControl2.initButtonNode")
        
        switch buttonStyle {
        case .CircleOrEllipse:
            buttonNode = SKShapeNode(ellipseOfSize: buttonSize)
            break
        default:
            buttonNode = SKShapeNode(rectOfSize: buttonSize)
        }
        
        buttonNode?.fillColor = buttonColor
    }
    
    func setupButtonBaseNode() {
        println("GameControl2.initButtonBaseNode")
        
        switch buttonStyle {
        case .CircleOrEllipse:
            var ellipseOfSize: CGSize = CGSizeMake(buttonSize.width + buttonPadding, buttonSize.height + buttonPadding)
            buttonBaseNode = SKShapeNode(ellipseOfSize: ellipseOfSize)
            break
        default:
            var rectOfSize: CGSize = CGSizeMake(buttonSize.width + buttonPadding, buttonSize.height + buttonPadding)
            buttonBaseNode = SKShapeNode(rectOfSize: rectOfSize)
        }
        
        buttonBaseNode?.fillColor = buttonBaseColor
    }

    var delagate: GameControl2Protocol? {
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
            delagate?.gameControlMoved(self, velocity: self.velocity, angularVelocity: self.angularVelocity)
        } else if isClicking {
            delagate?.gameControlClicked(self)
        }
    }
    
    convenience override init() {
        self.init(size: nil, style: nil, type: nil, color: nil, depressColor: nil, padding: nil)
    }
    
    convenience init(style: ControlStyle?, type: ControlType?, padding: CGFloat?) {
        self.init(size: nil, style: style, type: type, color: nil, depressColor: nil, padding: padding)
    }
    
    init(size: CGSize?, style: ControlStyle?, type: ControlType?, color: SKColor?, depressColor: SKColor?, padding: CGFloat?) {
        self.buttonSize = defButtonSize
        self.buttonStyle = style ?? ControlStyle.Default
        self.buttonType = type ?? ControlType.Default
        self.buttonColor = defButtonColor
        self.buttonBaseColor = defButtonBaseColor
        self.buttonCornerRadius = defCornerRadius
        self.buttonDepressColor = defDepressButtonColor
        self.buttonPadding = defButtonPadding

        if (padding != nil) {
            self.buttonPadding = padding!
        }
        
        super.init()
        
        self.setupButtonBaseNode()
        self.setupButtonNode()
        
        self.userInteractionEnabled = true;
        self.isTracking = false
        self.velocity = CGPointZero

        self.addChild(buttonBaseNode!)
        self.addChild(buttonNode!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        self.isTracking = false
        self.isClicking = false
        self.velocity = CGPointZero
        let easeOut: SKAction = SKAction.moveTo(self.anchorPointInPoints, duration: kThumbSpringBackDuration)
        easeOut.timingMode = SKActionTimingMode.EaseOut
        self.buttonNode.runAction(easeOut)
    }
    
    // touch begin
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        for touch: AnyObject in touches {
            let location: CGPoint = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            if self.buttonNode == touchedNode && self.buttonType == .Draggable && isTracking == false {
                isTracking = true
            } else if self.buttonNode == touchedNode && (self.buttonType == .Clickable || self.buttonType == .Default) && isClicking == false {
                isClicking = true
            }
        }
    }
    
    // touch move
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event);
        if buttonType == .Draggable {
            println("GameControl2.touchesEnded - dragging...")
            for touch: AnyObject in touches {
                let location = touch.locationInNode(self);
                let xDistance: Float = Float(location.x - self.buttonNode.position.x)
                let yDistance: Float = Float(location.y - self.buttonNode.position.y)
                if self.isTracking == true && sqrtf(powf(xDistance, 2) + powf(yDistance, 2)) <= Float(self.buttonSize.width * 2) {
                    let xAnchorDistance: CGFloat = (location.x - self.anchorPointInPoints.x)
                    let yAnchorDistance: CGFloat = (location.y - self.anchorPointInPoints.y)
                    if sqrt(pow(xAnchorDistance, 2) + pow(yAnchorDistance, 2)) <= self.buttonSize.width {
                        let moveDifference: CGPoint = CGPointMake(xAnchorDistance , yAnchorDistance)
                        self.buttonNode?.position = CGPointMake(self.anchorPointInPoints.x + moveDifference.x, self.anchorPointInPoints.y + moveDifference.y)
                    } else {
                        let magV = sqrt(xAnchorDistance * xAnchorDistance + yAnchorDistance * yAnchorDistance)
                        let aX = self.anchorPointInPoints.x + xAnchorDistance / magV * self.buttonSize.width
                        let aY = self.anchorPointInPoints.y + yAnchorDistance / magV * self.buttonSize.width
                        self.buttonNode?.position = CGPointMake(aX, aY)
                    }
                    let tNAnchPoinXDiff: CGFloat = self.buttonNode.position.x - self.anchorPointInPoints.x;
                    let tNAnchPoinYDiff: CGFloat = self.buttonNode.position.y - self.anchorPointInPoints.y
                    self.velocity = CGPointMake(tNAnchPoinXDiff, tNAnchPoinYDiff)
                    self.angularVelocity = -atan2f(Float(tNAnchPoinXDiff), Float(tNAnchPoinYDiff))
                }
            }
        }/* else if buttonType == .Clickable {
            var initialPoint: CGPoint = self.position;
            var amplitudeX: NSInteger = 32;
            var amplitudeY: NSInteger = 2;
            var randomActions = [NSMutableArray]();
            for (int i = 0; i < times; i++) {
                var randX: NSInteger = self.position.x+arc4random() % amplitudeX - amplitudeX/2;
                var randY: NSInteger = self.position.y+arc4random() % amplitudeY - amplitudeY/2;
                var action = [SKAction moveTo:CGPointMake(randX, randY) duration:0.01];
                randomActions.addObject(action)
            }
            
            let actionSeq = SKAction(s
            butto
        }*/
    }
    
    // touch end
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if buttonType == .Clickable || buttonType == .Default {
            println("GameControl2.touchesEnded - click!")
        }
        
        reset()
    }
    
    // touch cancel
    override func touchesCancelled(touches: NSSet, withEvent event: UIEvent!) {
        if buttonType == .Clickable || buttonType == .Default {
            println("GameControl2.touchesCancelled - click!")
        }
        
        reset()
    }
}