//
//  KeyboardPanel.swift
//  the MC
//
//  Created by Lewis, Kenneth on 6/23/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit

class KeyboardPanel: UIView {
    var left:UILabel = UILabel()
    var right:UILabel = UILabel()
    
    required init(coder:NSCoder) {
        super.init(coder:coder)
        
        println("KeyboardPanel.init(coder)")
        setupUI()
    }
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        println("KeyboardPanel.init(frame)")
        setupUI()
    }
    
    func setupUI() {
        println("KeyboardPanel.setupUI")
        addSubview(left)
        addSubview(right)
        updateUI()
        setNeedsUpdateConstraints()
    }
    
    func updateUI() {
        println("KeyboardPanel.updateUI")
        left.text = "Left"
        right.text = "Right"
    }
    
    override func updateConstraints() {
        setTranslatesAutoresizingMaskIntoConstraints(false)
        left.setTranslatesAutoresizingMaskIntoConstraints(false)
        right.setTranslatesAutoresizingMaskIntoConstraints(false)
        removeConstraints(constraints())
        // add constraints here
        
        // left.width = right.width * 1 + 0
        let equalWidths = NSLayoutConstraint(
            item: left,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: right,
            attribute: .Width,
            multiplier: 1,
            constant: 0)
        addConstraint(equalWidths)
        
        let namedViews = ["left":left, "right":right]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[left]-[right]-|",
                options: nil, metrics: nil, views: namedViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[left]-|",
                options: nil, metrics: nil, views: namedViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[right]-|",
                options: nil, metrics: nil, views: namedViews))
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        println("KeyboardPanel.layoutSubviews")
        updateUI()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
}
