//
//  MasterViewController.swift
//  HeroMusic2
//
//  Created by Lewis, Kenneth on 2/16/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil

    var objects = [HeroMusic2]()

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepareForSegue segue.identifier=\(segue.identifier)")
        if segue.identifier == "editDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                    let object = objects[indexPath.row] as HeroMusic2
                    let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailTableViewController
                    controller.detailItem = object
            }
        }
    }
    
    // MARK: - Table View

    // get table row count
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    // populate table row cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
                as UITableViewCell
            
        let object = objects[indexPath.row]
            cell.textLabel!.text = object.valueForKey("name") as String?
        
        return cell
    }

    // allow table editing
    override func tableView(tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
    }
    
    // update table row cells - only handling deletes
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
                let object = objects[indexPath.row] as HeroMusic2
                
                managedObjectContext!.deleteObject(object)
                
                if object.deleted{
                    println("Successfully deleted HeroMusic=\(object.name)")
                    
                    var savingError: NSError?
                    if managedObjectContext!.save(&savingError){
                        println("Successfully saved the context")
                        objects.removeAtIndex(indexPath.row)
                    } else {
                        if let error = savingError{
                            println("Failed to save the context. Error = \(error)")
                        }
                    }
                    
                } else {
                    println("Failed to delete HeroMusic=\(object.name)")
                }
                
                tableView.deleteRowsAtIndexPaths([indexPath],
                    withRowAnimation: .Fade)
            }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest = NSFetchRequest(entityName:"HeroMusic2")
        
        var error: NSError?
        let fetchedResults = managedObjectContext!.executeFetchRequest(fetchRequest,
            error: &error) as [HeroMusic2]?
        
        if let results = fetchedResults {
            objects = results
            println("viewWillAppear - fetched \(objects.count) results")
            self.tableView.reloadData()
        } else {
            println("viewWillAppear - Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    @IBAction func cancelSaveDetail(segue:UIStoryboardSegue) {
        println("cancelSaveDetail")
    }
    
    @IBAction func cancelEditDetail(segue:UIStoryboardSegue) {
        println("cancelEditDetail")
    }
    
    @IBAction func saveDetail(segue:UIStoryboardSegue) {
        println("saveDetail")
        
        // 1. Create a new object from the SQLite data store
        let entity = NSEntityDescription.entityForName("HeroMusic2",
            inManagedObjectContext:
            managedObjectContext!)
        var object = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedObjectContext) as? HeroMusic2
        
        // 2. Set the values
        let viewController = segue.sourceViewController as DetailViewController
        object?.name = viewController.nameTextField.text
        
        // 3. Save the SQLite object
        var savingError: NSError?
        if managedObjectContext!.save(&savingError){
            println("Successfully saved the context")
            objects.append(object!)
        } else {
            // 4. Add the SQLite object to the objects array
        }
        if let error = savingError {
            println("Failed to save the context. Error = \(error)")
        }
    }
    
    @IBAction func editDetail(segue:UIStoryboardSegue) {
        println("editDetail")
        
        let viewController = segue.sourceViewController as DetailViewController
        var object = viewController.detailItem
        object?.name = viewController.nameTextField.text
        
        var savingError: NSError?
        if managedObjectContext!.save(&savingError){
            println("Successfully saved the context")
        }
        if let error = savingError {
             println("Failed to save the context. Error = \(error)")
        }
    }
}

