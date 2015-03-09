//
//  DetailViewController.swift
//  HeroMusic2
//
//  Created by Lewis, Kenneth on 2/16/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
   
    var detailItem: HeroMusic2? {
        didSet {
            // Update the view.
            println("detailItem - didSet")
            self.configureView()
        }
    }
    
    func configureView() {
        println("DetailViewController.configureView")
        // Update the user interface for the detail item.
        if let object = self.detailItem as HeroMusic2? {
            println("Has detailItem=\(object.name)")
            
            if let nameField = self.nameTextField {
                nameField.text = object.name
                println("nameField.text=\(nameField.text)")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        println("DetailViewController.viewDidLoad")
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
}