//
//  GameScene.swift
//  FightKnights
//
//  Created by Lewis, Kenneth on 5/10/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, GameControl2Protocol {
    let heroCategory: UInt32 = 1 << 0
    let groundCategory: UInt32 = 1 << 1
    let levelCategory: UInt32 = 1 << 2
    let levelItemCategory: UInt32 = 1 << 3
    let powerupCategory: UInt32 = 1 << 4
    let deathtrapCategory: UInt32 = 1 << 5
    let finishCategory: UInt32 = 1 << 6
    
    let levelItemZPosition: CGFloat = -5
    let BackgroundZPosition: CGFloat = -10
    
    let directionControl: GameControl2 = GameControl2(style: ControlStyle.CircleOrEllipse, type: ControlType.Draggable, padding: 15)
    let actionControl: GameControl2 = GameControl2(style: nil, type: nil, padding: 15)
    
    var appleNode: SKSpriteNode?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        println("GameScene.didMoveToView")
        
        let bgDiametr: CGFloat = 120
        let thumbDiametr: CGFloat = 60
        let joysticksRadius = bgDiametr / 2
        directionControl.position = CGPointMake(joysticksRadius + 30, joysticksRadius + 130)
        directionControl.delagate = self
        self.addChild(directionControl)

        actionControl.position = CGPointMake(joysticksRadius + 870, joysticksRadius + 130)
        actionControl.delagate = self
        self.addChild(actionControl)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        
        // apple
        appleNode = SKSpriteNode(imageNamed: "apple")
        if let aN = appleNode {
            aN.physicsBody = SKPhysicsBody(texture: aN.texture, size: aN.size)
            aN.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            aN.physicsBody?.affectedByGravity = false;
            self.insertChild(aN, atIndex: 0)
        }
        
        setupAccessories()
    }
    
    private func setupAccessories() {
        for child in self.children as [SKNode] { 	    //#1
            if var sprite = child as? SKSpriteNode {    //#2
                if sprite.name == .None {
                    continue
                }
                
                sprite.zPosition = levelItemZPosition   //#3
                if let spriteSpec = sprite.name {       //#3
                    var components = spriteSpec.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "|"))
                    if (components.count <= 1) {     //#4
                        println("SKNode - sprite.name: \(spriteSpec)")
                        if ensurePhysicsBody(sprite) {
                            sprite.physicsBody?.categoryBitMask |= levelItemCategory
                            sprite.physicsBody?.collisionBitMask |= heroCategory
                        }
                        continue
                    }
                    
                    /*
                    sprite.name = components[0]        	//#5
                    components.removeAtIndex(0)         //#5
                    
                    for accessory in components {		//#6
                        println("SKNode - accessory: \(accessory)")
                        switch accessory      {  //#7
                        case "background":       //#8
                            sprite.zPosition = BackgroundZPosition
                            
                        case "finish":           //#9
                            if ensurePhysicsBody(sprite, useTextureAlpha: false) {
                                sprite.physicsBody?.categoryBitMask |= finishCategory
                                sprite.physicsBody?.collisionBitMask |= heroCategory
                            }
                            sprite.alpha = 0
                            
                        case "powerup":         //#10
                            if ensurePhysicsBody(sprite) {
                                sprite.physicsBody?.categoryBitMask |= powerupCategory
                                sprite.physicsBody?.contactTestBitMask |= heroCategory
                            }
                            
                        case "death":           //#11
                            if ensurePhysicsBody(sprite) {
                                sprite.physicsBody?.categoryBitMask |= deathtrapCategory
                                sprite.physicsBody?.collisionBitMask |= heroCategory
                            }
                            
                        default:                //#12
                            if ensurePhysicsBody(sprite) {
                                sprite.physicsBody?.categoryBitMask |= levelItemCategory
                                sprite.physicsBody?.collisionBitMask |= heroCategory
                            }
                        }
                    }*/
                }
            }
        }
    }
    
    private func ensurePhysicsBody(sprite: SKSpriteNode, useTextureAlpha: Bool = true) -> Bool { //#1
        // Make sure our sprite has a physicsBody
        if sprite.physicsBody == .None {    //#2
            // First, try to create a physicsBody from the texture alpha
            if useTextureAlpha && sprite.texture != .None {
                sprite.physicsBody = SKPhysicsBody(texture: sprite.texture, alphaThreshold: 0.9, size: sprite.size)
            }
            // Next, try to create a physicsBody from the sprite's smallest
            // bounding rectangle
            if sprite.physicsBody == .None {
                NSLog("*** Falling back to rectangle for sprite: \(sprite.name)")
                sprite.physicsBody = SKPhysicsBody(rectangleOfSize: sprite.frame.size)
            }
            
            // If we still don't have a physicsBody, just move on to the next one
            if sprite.physicsBody == nil {
                NSLog("*** Falling back to no physicsBody for sprite: \(sprite.name)")
                return false
            }
            // Default these to no collisions/contacts
            sprite.physicsBody?.categoryBitMask = 0
            sprite.physicsBody?.collisionBitMask = 0
            sprite.physicsBody?.contactTestBitMask = 0
        }
        // Defaults for the physics body
        sprite.physicsBody?.dynamic = false
        return true
    }
    
    /*override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }*/

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        super.touchesBegan(touches, withEvent: event)
        
        println("GameScene.touchesBegan")
        
        /*        if let touch = touches.first as? UITouch {*/
        //appleNode?.position = touch.locationInNode(self)
        
        /*for touch: AnyObject in touches {
            var first = touch as? UITouch
            appleNode?.position = first?.locationInNode(self) as CGPoint!
            break;
        }*/
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func gameControlMoved(gameControl: GameControl2, velocity: CGPoint, angularVelocity: Float) {
        println("GameScene.gameControlMoved")
        
        if let aN = appleNode {
            if gameControl.isEqual(directionControl) {
                aN.position = CGPointMake(aN.position.x + (velocity.x * 0.12), aN.position.y + (velocity.y * 0.12))
            } else if gameControl.isEqual(actionControl) {
                aN.zRotation = CGFloat(angularVelocity)
            }
        }
    }
}
