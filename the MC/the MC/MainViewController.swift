//
//  MainView.swift
//  the MC
//
//  Created by Lewis, Kenneth on 6/13/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    //let rootNote = KeyboardNote(frame: CGRectZero)
    //let secondNote = KeyboardNote(frame: CGRectZero)
    //let thirdNote = KeyboardNote(frame: CGRectZero)
    //let fourthNote = KeyboardNote(frame: CGRectZero)
    //let fifthNote = KeyboardNote(frame: CGRectZero)
    //let sixthNote = KeyboardNote(frame: CGRectZero)
    //let seventhNote = KeyboardNote(frame: CGRectZero)
    //let eighthNote = KeyboardNote(frame: CGRectZero)
    
    let kbPanel = KeyboardPanel(frame: CGRectZero)
    
    override func viewDidLoad() {
        println("MainViewController.viewDidLoad")
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.yellowColor()
        
        //view.addSubview(rootNote)
        view.addSubview(kbPanel)
    }
    
    // Moved logic to KeyboardNote.updateLayerFrames
    override func viewDidLayoutSubviews() {
        println("MainViewController.viewDidLayoutSubviews - view.bounds.width=\(view.bounds.width), topLayoutGuide.length=\(topLayoutGuide.length)")
        
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        //rootNote.frame = CGRect(x: margin, y: margin + topLayoutGuide.length,
          //  width: width, height: 31.0)
        kbPanel.frame = CGRect(x: margin, y: margin + topLayoutGuide.length, width: width, height: view.bounds.width - 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
