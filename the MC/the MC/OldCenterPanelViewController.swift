//
//  CenterPanelViewController.swift
//  the MC
//
//  Created by Lewis, Kenneth on 6/3/15.
//  Copyright (c) 2015 Lewis, Kenneth. All rights reserved.
//

import UIKit

@objc
protocol OldCenterViewControllerDelegate {
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class OldCenterPanelViewController: UICollectionViewController {
    
    var delegate: OldCenterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OldCenterPanelViewController: SidePanelViewControllerDelegate {
    func panelClicked(message: String) {
        println("panelClicked - message=\(message)")
        delegate?.collapseSidePanels?()
    }
}