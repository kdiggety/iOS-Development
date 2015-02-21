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
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveDetailBtn: UIButton!
   
    var detailItem: HeroMusic2? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        let object = self.detailItem as HeroMusic2?
        println("Has detailItem=\(object)")
        
        if let nameField = self.nameTextField {
            nameField.text = object?.name
            println("nameField.text=\(nameField.text)")
        }

        // KRL : cleanup?
        if let button = self.saveDetailBtn {
            //saveDetailBtn.addTarget(self, action: "insertNewObject:", forControlEvents: .TouchUpInside)
            println("button.titleLabel?.text=\(button.titleLabel?.text)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

