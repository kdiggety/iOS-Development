//
//  CenterPanelViewController.swift
//  the MC
//
//  Created by Lewis, Kenneth on 6/7/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

let reuseIdentifier = "CellPadView"

class CenterPanelViewController: UICollectionViewController {
    
    var cellPad: [UIColor]?
    var delegate: CenterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        var tempArray: Array<UIColor> = Array<UIColor>()
        
        var redValue: CGFloat = 0.0
        var blueValue: CGFloat = 0.0
        var greenValue: CGFloat = 0.0
        
        for index in 1...24 {
            redValue = CGFloat(arc4random() % 255) / 255.0
            blueValue = CGFloat(arc4random() % 255) / 255.0
            greenValue = CGFloat(arc4random() % 255) / 255.0
            
            tempArray.append(UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0))
        }
        
        cellPad = tempArray as [UIColor]?
        
        var singleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleSingleTapGesture:"))
        singleTapGesture.delaysTouchesBegan = true
        singleTapGesture.numberOfTapsRequired = 1 // number of taps required
        singleTapGesture.numberOfTouchesRequired = 1 // number of finger touches required
        self.collectionView?.addGestureRecognizer(singleTapGesture)
        
        var longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPressGesture:"))
        longPressGesture.delaysTouchesBegan = true
        longPressGesture.minimumPressDuration = 0.05
        longPressGesture.numberOfTapsRequired = 0 // number of taps required
        longPressGesture.numberOfTouchesRequired = 1 // number of finger touches required
        self.collectionView?.addGestureRecognizer(longPressGesture)
    }

    func handleSingleTapGesture(sender: UITapGestureRecognizer) {
        println("handleSingleTapGesture - sender.state=\(sender.state.rawValue)")
        if (sender.state == .Ended) {
            var location: CGPoint = sender.locationInView(self.collectionView)
            var indexPath: NSIndexPath? = self.collectionView?.indexPathForItemAtPoint(location)
    
            if (indexPath != nil) {
                println("Cell view was tapped.")
                var cell: CellPadView? = self.collectionView?.cellForItemAtIndexPath(indexPath!) as? CellPadView
                
                UIView.animateWithDuration(0.5, animations: {
                    cell?.backgroundColor = UIColor.magentaColor()
                    cell?.backgroundColor = self.cellPad?[indexPath!.item]
                })
            }
        } else{
            // Handle other UIGestureRecognizerState's
        }
    }
    
    func handleLongPressGesture(sender: UITapGestureRecognizer) {
        println("handleLongPressGesture - sender.state=\(sender.state.rawValue)")
        if (sender.state == .Began) {
            var location: CGPoint = sender.locationInView(self.collectionView)
            var indexPath: NSIndexPath? = self.collectionView?.indexPathForItemAtPoint(location)
            
            if (indexPath != nil) {
                println("Cell view was pressed.")
                var cell: CellPadView? = self.collectionView?.cellForItemAtIndexPath(indexPath!) as? CellPadView
                cell?.backgroundColor = UIColor.magentaColor()
            }
        } else if (sender.state == .Ended) {
            var location: CGPoint = sender.locationInView(self.collectionView)
            var indexPath: NSIndexPath? = self.collectionView?.indexPathForItemAtPoint(location)
            
            if (indexPath != nil) {
                println("Cell view was pressed.")
                var cell: CellPadView? = self.collectionView?.cellForItemAtIndexPath(indexPath!) as? CellPadView
                cell?.backgroundColor = self.cellPad?[indexPath!.item]
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundColor = UIColor.magentaColor()
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        var cell : UICollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath)!
        cell.backgroundColor = cellPad?[indexPath.item]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return 8
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CellPadView
    
        // Configure the cell
        cell.backgroundColor = cellPad?[indexPath.item]
        cell.padLabel.text = "blah?"
        
        //var tempLabel: UILabel = UILabel()
        //tempLabel.text = String(indexPath.item)
        //cell.addSubview(tempLabel)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
}

extension CenterPanelViewController: SidePanelViewControllerDelegate {
    func panelClicked(message: String) {
        println("panelClicked - message=\(message)")
        delegate?.collapseSidePanels?()
    }
}