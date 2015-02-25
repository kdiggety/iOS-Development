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
    var imManagedObjectContext: NSManagedObjectContext? = nil

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

    /*func insertNewObject(sender: AnyObject) {
        let detailViewController = sender as? DetailViewController;
        
        println("insertNewObject - heroMusic.name=\(detailViewController?.detailItem?.name)")
        
        var savingError: NSError?
        if managedObjectContext!.save(&savingError){
            println("Successfully saved the new HeroMusic")
        } else {
            if let error = savingError{
                println("Failed to save the new HeroMusic. Error = \(error)")
            }
        }
        
        //objects.append(heroMusic)
        //self.tableView.reloadData()
     }*/

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("prepareForSegue segue.identifier=\(segue.identifier)")
        if segue.identifier == "addDetail" {
            let entity =  NSEntityDescription.entityForName("HeroMusic2",
                inManagedObjectContext:
                imManagedObjectContext!)
            let object = NSManagedObject(entity: entity!,
                insertIntoManagedObjectContext:imManagedObjectContext) as HeroMusic2
            
            object.name = "New Hero Music"
            println("addDetail - detailItem=\(object.name)")
            
            let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            controller.detailItem = object
            //controller.navigationItem.leftBarButtonItem =
                //self.splitViewController?.displayModeButtonItem()
            //controller.navigationItem.leftItemsSupplementBackButton = true
        } else if segue.identifier == "editDetail" {
            if let indexPath =
                self.tableView.indexPathForSelectedRow() {
                    let object = objects[indexPath.row] as HeroMusic2
                    println("editDetail - detailItem=\(object.name)")
                    let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                    controller.detailItem = object
                    //controller.navigationItem.leftBarButtonItem =
                        //self.splitViewController?.displayModeButtonItem()
                    //controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        //return sectionInfo.numberOfObjects
        return objects.count
    }

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

    override func tableView(tableView: UITableView,
        canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
    }
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
            println("fetched \(objects.count) results")
            self.tableView.reloadData()
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    @IBAction func cancelSaveDetail(segue:UIStoryboardSegue) {
        let moc = detailViewController?.detailItem?.managedObjectContext
        println("cancelSaveDetail - managedObjectContext=\(moc)")
    }
    
    @IBAction func cancelEditDetail(segue:UIStoryboardSegue) {
        let moc = detailViewController?.detailItem?.managedObjectContext
        println("cancelSaveDetail - managedObjectContext=\(moc)")
    }
    
    @IBAction func saveDetail(segue:UIStoryboardSegue) {
        let moc = detailViewController?.detailItem?.managedObjectContext
        println("saveDetail - managedObjectContext=\(moc)")
    }
    
    @IBAction func editDetail(segue:UIStoryboardSegue) {
        let moc = detailViewController?.detailItem?.managedObjectContext
        println("editDetail - managedObjectContext=\(moc)")
    }
}

