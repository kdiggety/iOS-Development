//
//  DetailViewController.swift
//  HeroMusic2
//
//  Created by Lewis, Kenneth on 2/16/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBAction func changedName(sender: UITextField) {
        if let nameField = self.nameTextField {
            //self.detailItem?.name = nameField.text
            self.detailItem?.setValue(nameField.text, forKey: "name")
            println("updateDetail - nameField.text=\(nameField.text)")
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
   
    var detailItem: HeroMusic2? {
        didSet {
            // Update the view.
            // TODO : KRL - Commented because it did not seem to configure the view
            //println("detailItem - didSet")
            //self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        let object = self.detailItem as HeroMusic2?
        println("Has detailItem=\(object?.name)")
        
        if let nameField = self.nameTextField {
            nameField.text = object?.name
            println("nameField.text=\(nameField.text)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("DetailViewController.viewDidLoad")
        self.configureView()
    }
}

