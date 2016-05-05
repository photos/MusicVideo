//
//  SettingsTVC.swift
//  MusicVideo
//
//  Created by Forrest Collins on 5/4/16.
//  Copyright © 2016 bananapps. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController {

    @IBOutlet weak var aboutDisplay: UILabel!
    @IBOutlet weak var feedbackDisplay: UILabel!
    @IBOutlet weak var securityDisplay: UILabel!
    
    @IBOutlet weak var touchID: UISwitch!
    @IBOutlet weak var bestImageDisplay: UILabel!
    @IBOutlet weak var apiCount: UILabel!
    @IBOutlet weak var sliderCount: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SettingsTVC.preferredFontChange), name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        tableView.alwaysBounceVertical = false
        
        title = "Settings"
        
        touchID.on = NSUserDefaults.standardUserDefaults().boolForKey("SecSetting")
        
        if NSUserDefaults.standardUserDefaults().objectForKey("APICNT") != nil {
            let theValue = NSUserDefaults.standardUserDefaults().objectForKey("APICNT") as! Int
            apiCount.text = "\(theValue)"
            sliderCount.value = Float(theValue)
        } else {
            // set to 10 by default
            sliderCount.value = 10.0
            apiCount.text = "\(Int(sliderCount.value))"
        }
    }
    
    func preferredFontChange() {
        
        aboutDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        feedbackDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        securityDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        bestImageDisplay.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        apiCount.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }
    
    // Remove observer, called just as object is about to be deallocated
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }

    @IBAction func touchIdTapped(sender: UISwitch) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if touchID.on {
            defaults.setBool(touchID.on, forKey: "SecSetting")
        } else {
            defaults.setBool(false, forKey: "SecSetting")
        }
    }
    
    @IBAction func valueChanged(sender: UISlider) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(Int(sliderCount.value), forKey: "APICNT")
        apiCount.text = "\(Int(sliderCount.value))"
    }
}
