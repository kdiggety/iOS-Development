//
//  ViewController.swift
//  AutoConstraints
//
//  Created by Lewis, Kenneth on 7/1/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get a reference to the superview
        let superview = self.view
        
        //Create a label
        let myLabel = UILabel()
        myLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        myLabel.text = "My Label"
        
        //Create a button
        let myButton = UIButton()
        myButton.backgroundColor = UIColor.redColor()
        myButton.setTitle("My Button", forState: UIControlState.Normal)
        myButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Add the button and label to the superview
        superview.addSubview(myLabel)
        superview.addSubview(myButton)
        
        // Create the views dictionary
        let viewsDictionary = ["myLabel": myLabel, "myButton": myButton]
        
        // Create and add the vertical constraints
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[myButton]-|",
            options: NSLayoutFormatOptions.AlignAllBaseline,
            metrics: nil,
            views: viewsDictionary))
        
        // Create and add the horizontal constraints
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[myButton]-[myLabel(==myButton)]-|",
                options: NSLayoutFormatOptions.AlignAllBaseline, 
                metrics: nil, 
                views: viewsDictionary))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

