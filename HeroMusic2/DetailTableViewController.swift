//
//  DetailTableViewController.swift
//  HeroMusic2
//
//  Created by Lewis, Kenneth on 3/7/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit
import MapKit

class DetailTableViewController: UITableViewController, UITableViewDelegate {
    
    let kNameCellID: NSString = "nameCell";
    let kTimeCellID: NSString = "timeCell";
    let kTimePickerCellID: NSString = "timePickerCell";
    let kMapCellID: NSString = "mapCell";

    let nameTag: Int = 1;
    let timeTitleTag: Int = 2;
    let timeDetailTag: Int = 3;
    let timePickerTag: Int = 4;
    let mapTag: Int = 5;
    
    var dateFormatter: NSDateFormatter? = nil
    var timePickerIndexPath: NSIndexPath? = nil
    
    var detailItem: HeroMusic2? {
        didSet {
            // Update the view.
            println("detailItem - didSet")
            self.configureView()
        }
    }
    
    func createDateFormatter() {
        dateFormatter = NSDateFormatter()
        dateFormatter?.dateStyle = NSDateFormatterStyle.NoStyle
        dateFormatter?.timeStyle = NSDateFormatterStyle.LongStyle
    }
    
    func configureView() {
        println("DetailViewController.configureView")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("DetailViewController.viewDidLoad")
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.createDateFormatter()
        self.configureTableView()
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func datePickerIsShown() -> Bool {
        return self.timePickerIndexPath != nil;
    }
    
    // MARK: - Table View
    
    // get table row count
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows: Int = 4
        
        if datePickerIsShown() {
            numberOfRows++;
        }
        
        return numberOfRows
    }
    
    // populate table row cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil

        switch indexPath.row {
        case 0:
            cell = createNameCell()
        case 1:
            cell = timeCell(true)
        case 2:
            cell = timeCell(false)
        case 3:
            cell = mapCell()
        default:
            cell = createNameCell()
        }
        
        return cell!
    }
    
    func createNameCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("nameCell") as UITableViewCell

        let nameLabel: UITextField = cell.viewWithTag(nameTag) as UITextField
        nameLabel.text = detailItem?.name

        return cell;
    }
    
    func timeCell(isStartTime: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("timeCell") as UITableViewCell
        
        let timeLabel = (isStartTime) ? "Start Time" : "EndTime"
            
        let timeTitle: UILabel = cell.viewWithTag(timeTitleTag) as UILabel
        timeTitle.text = timeLabel

        let timeDetail: UILabel = cell.viewWithTag(timeDetailTag) as UILabel
        timeDetail.text = dateFormatter?.stringFromDate(NSDate())
        
        return cell;
    }
    
    func mapCell() -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mapCell") as UITableViewCell
        
        let mapView: MKMapView = cell.viewWithTag(mapTag) as MKMapView
        let location = CLLocationCoordinate2D(
            latitude: 51.50007773,
            longitude: -0.1246402
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        return cell;
    }
    
    /*override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }*/
    
    /*override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.hasImageAtIndexPath()) {
            return self.heightForImageCellAtIndexPath
        } else {
            return self.heightForBasicCellAtIndexPath
        }
    }*/
    
    /*
    func heightForImageCellAtIndexPat:(indexPath: NSIndexPath) -> CGFloat {
    static RWImageCell *sizingCell = nil
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    sizingCell = [self.tableView dequeueReusableCellWithIdentifier:RWImageCellIdentifier];
    });
    
    [self configureImageCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
    }*/
 
    /*override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row isLandscapeOrientation() {
            return 120.0
        } else {
            return 155.0
        }
    }*/
    
    func isLandscapeOrientation() -> Bool {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("SELECTED INDEX \(indexPath.row)")
    }
}