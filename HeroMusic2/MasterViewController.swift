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
    // TODO : KRL - Uncomment
    //var imManagedObjectContext: NSManagedObjectContext? = nil

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
        if segue.identifier == "addDetail" {
            
            var object: HeroMusic2? = nil
            
            let fetchRequest = NSFetchRequest(entityName:"HeroMusic2")
            
            var error: NSError?
            // TODO : KRL - Change the moc back to in memory
            let fetchedResults = managedObjectContext!.executeFetchRequest(fetchRequest,
                error: &error) as [HeroMusic2]?
            
            if let results = fetchedResults {
                println("prepareForSegue - fetched \(results.count) results")
                if results.count > 0 {
                    object = results[0]
                }
            }
            
            // TODO : KRL - Change the moc back to in memory
            if object == nil {
                let entity =  NSEntityDescription.entityForName("HeroMusic2",
                    inManagedObjectContext:
                    managedObjectContext!)
                object = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext:managedObjectContext) as? HeroMusic2
            }
            
            object?.name = "New Hero Music"
            println("addDetail - detailItem=\(object?.name)")
            
            let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            controller.detailItem = object
        } else if segue.identifier == "editDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                    let object = objects[indexPath.row] as HeroMusic2
                    let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                    //let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as? HeroMusic2
                    //let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                    println("editDetail - detailItem=\(object.name)")
                
                    controller.detailItem = object
            }
        }
        /*
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }*/
    }

    // TODO : KRL - Added temporarily
    /*var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "HeroMusic2")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        if !_fetchedResultsController!.performFetch(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil*/
    
    // MARK: - Table View

    // get table row count
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        //return sectionInfo.numberOfObjects
        return objects.count
    }

    // populate table row cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        //self.configureCell(cell, atIndexPath: indexPath)
        //return cell

        let cell =
            tableView.dequeueReusableCellWithIdentifier("Cell")
                as UITableViewCell
            
        let object = objects[indexPath.row]
            cell.textLabel!.text = object.valueForKey("name") as String?
        //println("tableView - cell.textLabel!.text=\(cell.textLabel!.text)")
            
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
        
        var imObject: HeroMusic2? = nil
        
        // 1. Get the new object from the in-memory data store
        let controller = segue.sourceViewController as DetailViewController
        imObject = controller.detailItem
        println("saveDetail - detailItem=\(imObject?.name)")
        
        // 2. Create a new object from the SQLite data store
        
        // 3. Copy the values from the new in-memory object to the SQLite object
        
        // 4. Save the SQLite object
        
        // 5. Add the SQLite object to the objects array

    }
    
    @IBAction func editDetail(segue:UIStoryboardSegue) {
        println("editDetail")
        
        var savingError: NSError?
        if managedObjectContext!.save(&savingError){
            println("Successfully saved the context")
        }
        if let error = savingError {
            println("Failed to save the context. Error = \(error)")
        }
        
        if managedObjectContext!.save(&savingError){
            println("Successfully saved the context")
        }
        if let error = savingError {
            println("Failed to save the context. Error = \(error)")
        }
    }
}

