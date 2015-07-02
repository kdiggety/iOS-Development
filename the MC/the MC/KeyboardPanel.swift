//
//  KeyboardPanel.swift
//  the MC
//
//  Created by Lewis, Kenneth on 6/23/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit

class KeyboardPanel: UIView {
    let rootNote = KeyboardNote(frame: CGRectZero)
    let secondNote = KeyboardNote(frame: CGRectZero)
    let thirdNote = KeyboardNote(frame: CGRectZero)
    let fourthNote = KeyboardNote(frame: CGRectZero)
    let fifthNote = KeyboardNote(frame: CGRectZero)
    let sixthNote = KeyboardNote(frame: CGRectZero)
    let seventhNote = KeyboardNote(frame: CGRectZero)
    let eighthNote = KeyboardNote(frame: CGRectZero)
    
    let myLabel = UILabel()
    let myButton = UIButton()
    
    var panGestureRecognizer: UIPanGestureRecognizer!
    
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
        
        self.tag = 123
        self.backgroundColor = UIColor.cyanColor()
        
        addSubview(rootNote)
        addSubview(secondNote)
        addSubview(thirdNote)
        addSubview(fourthNote)
        addSubview(fifthNote)
        addSubview(sixthNote)
        addSubview(seventhNote)
        addSubview(eighthNote)
        
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGestures:")
        
        updateUI()
        setNeedsUpdateConstraints()
    }
    
    func updateUI() {
        println("KeyboardPanel.updateUI")
        
        let margin: CGFloat = 8.0
        let width = self.bounds.width - 2.0 * margin
        
        println("KeyboardPanel.updateUI - self.bounds.width=\(self.bounds.width), margin=\(margin), width=\(width)")
     }
    
    override func updateConstraints() {
        println("KeyboardPanel.updateConstraints")

        //setTranslatesAutoresizingMaskIntoConstraints(false)

        rootNote.setTranslatesAutoresizingMaskIntoConstraints(false)
        secondNote.setTranslatesAutoresizingMaskIntoConstraints(false)
        thirdNote.setTranslatesAutoresizingMaskIntoConstraints(false)
        fourthNote.setTranslatesAutoresizingMaskIntoConstraints(false)
        fifthNote.setTranslatesAutoresizingMaskIntoConstraints(false)
        sixthNote.setTranslatesAutoresizingMaskIntoConstraints(false)
        seventhNote.setTranslatesAutoresizingMaskIntoConstraints(false)
        eighthNote.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        removeConstraints(constraints())

        let namedViews = ["rootNote": rootNote, "secondNote": secondNote, "thirdNote": thirdNote, "fourthNote": fourthNote, "fifthNote": fifthNote, "sixthNote": sixthNote, "seventhNote": seventhNote, "eighthNote": eighthNote]
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[rootNote]-[secondNote(==rootNote)]-[thirdNote(==rootNote)]-[fourthNote(==rootNote)]-[fifthNote(==rootNote)]-[sixthNote(==rootNote)]-[seventhNote(==rootNote)]-[eighthNote(==rootNote)]-|", options: nil, metrics: nil, views: namedViews))

        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[rootNote]-|",
            options: nil, metrics: nil, views: namedViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[secondNote]-|",
            options: nil, metrics: nil, views: namedViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[thirdNote]-|",
            options: nil, metrics: nil, views: namedViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[fourthNote]-|",
            options: nil, metrics: nil, views: namedViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[fifthNote]-|",
            options: nil, metrics: nil, views: namedViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[sixthNote]-|",
            options: nil, metrics: nil, views: namedViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[seventhNote]-|",
            options: nil, metrics: nil, views: namedViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[eighthNote]-|",
            options: nil, metrics: nil, views: namedViews))
        
        super.updateConstraints()
    }
    
    override func layoutSubviews() {
        println("KeyboardPanel.layoutSubviews")
        updateUI()
    }
    
    func handlePanGestures(sender: UIPanGestureRecognizer){
        println("KeyboardPanel.handlePanGestures")
        
        if sender.state != .Ended && sender.state != .Failed{
            let location = sender.locationInView(sender.view!.superview!)
            sender.view!.center = location
        }
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("KeyboardPanel.touchesBegan")
        
        if let touch = touches.first as? UITouch {
            // ...
        }
        super.touchesBegan(touches , withEvent:event)
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("KeyboardPanel.touchesEnded")
        
        if let touch = touches.first as? UITouch {
            // ...
        }
        super.touchesBegan(touches , withEvent:event)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    
}
