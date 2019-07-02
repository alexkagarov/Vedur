//
//  SettingsViewController.swift
//  Vedur
//
//  Created by Alex Kagarov on 6/22/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let testTemp = 296.15
    let testTime = "Sleeptoday, Jun 31, "
    
    @IBOutlet weak var testTempLabel: UILabel!
    
    @IBOutlet weak var testTimeLabel: UILabel!
    
    @IBOutlet weak var useCurLoc: UISwitch!
    
    @IBOutlet weak var timeFormat: UISegmentedControl!
    
    @IBOutlet weak var tempFormat: UISegmentedControl!
    
    @IBOutlet weak var curLocLbl: UILabel!
    
    @IBAction func tempFormatChanged(_ sender: UISegmentedControl) {
        switchTempFormat()
    }
    
    func switchTempFormat() {
        switch tempFormat.selectedSegmentIndex {
        case 0:
            testTempLabel.text = convertToCelcius(testTemp)
            defaults.set(0, forKey: "tempFormat")
        case 1:
            testTempLabel.text = convertToFahrenheit(testTemp)
            defaults.set(1, forKey: "tempFormat")
        case 2:
            testTempLabel.text = convertToKelvin(testTemp)
            defaults.set(2, forKey: "tempFormat")
        default:
            break
        }
    }
    
    func switchTimeFormat() {
        switch timeFormat.selectedSegmentIndex {
        case 0:
            testTimeLabel.text = testTime + "1:37 PM"
            defaults.set(0, forKey: "timeFormat")
        case 1:
            testTimeLabel.text = testTime + "13:37"
            defaults.set(1, forKey: "timeFormat")
        default:
            break
        }
    }
    
    @IBAction func timeFormatChanged(_ sender: UISegmentedControl) {
        switchTimeFormat()
    }
    
    func setSettingsFromDefaults() {
        timeFormat.selectedSegmentIndex = defaults.integer(forKey: "timeFormat")
        tempFormat.selectedSegmentIndex = defaults.integer(forKey: "tempFormat")
        useCurLoc.isOn = defaults.bool(forKey: "useCurrentLocation")
        switchTimeFormat()
        switchTempFormat()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSettingsFromDefaults()
        
        useCurLoc.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            curLocLbl.isHidden = !switchState.isOn
            defaults.set(true, forKey: "useCurrentLocation")
            addCurrentLocation()
        } else {
            curLocLbl.isHidden = !switchState.isOn
            defaults.set(false, forKey: "useCurrentLocation")
            removeCurrentLocation()
        }
    }

}
