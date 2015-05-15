//
//  ButtonGameControl.swift
//  FightKnights
//
//  Created by Lewis, Kenneth on 5/11/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import SpriteKit

class ButtonGameControl: GameControl2 {
    let depThumbNode: SKShapeNode, depBgNode: SKShapeNode
    
    func initDepressThumbNode() {
        println("GameControl2.initDepThumbNode")
    }
    
    func initDepressBgNode() {
        println("GameControl2.initDepBgnode")
    }
    
    init(rectOfSize: CGSize?, cornerRadius: CGFloat?, circleOfRadius: CGFloat?) {
        initDepressThumbNode()
        initDepressBgNode()
        super.init(rectOfSize: rectOfSize, cornerRadius: cornerRadius, circleOfRadius: <#CGFloat?#>)
    }

    init(rectOfSize: CGSize?, cornerRadius: CGFloat?, circleOfRadius: CGFloat?) {
        initDepressThumbNode()
        initDepressBgNode()
        super.init(rectOfSize: rectOfSize, cornerRadius: cornerRadius, circleOfRadius: <#CGFloat?#>)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        /*
        super.thumbNode = SKSpriteNode()
        super.bgNode = SKSpriteNode()
        self.depThumbNode = SKSpriteNode()
        self.depBgNode = SKSpriteNode()
        super.init()
        initDepressThumbImage(thumbImage, sizeToFit: true)
        initDepressBgImage(bgImage, sizeToFit: true)
        self.addChild(depBgNode) // first bg
        self.addChild(depThumbNode) // after thumb
    }*/
}