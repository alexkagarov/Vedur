//
//  SideMenuViewController.swift
//  Vedur
//
//  Created by Alex Kagarov on 6/22/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    //  OUTLETS:
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    let sideMenuSections = ["Locations", "Extra"]
    let sideMenuSettings = ["Edit locations", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:       #selector(updateTable), name: NSNotification.Name("UpdateTable"), object: nil)
    }
    
    @objc func updateTable() {
        sideMenuTableView.reloadData()
    }
    
}

extension SideMenuViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sideMenuSections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sideMenuSections[section]
    }
}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let city = cities[indexPath.row]
            guard let selectedCityName = city.value(forKey: "name") as? String else {return}
            
            let selectedCityInfo = ["selectedCityIndex":indexPath.row]
            let selectedCity = ["selectedCity":city]
            
            print("cell \(selectedCityName) was tapped")
            
            NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("GoToCity"), object: nil, userInfo: selectedCityInfo)
            NotificationCenter.default.post(name: NSNotification.Name("PassCity"), object: nil, userInfo: selectedCity)
            
        case 1:
            switch indexPath.item {
            case 0:
                print("edit cities cell was tapped")
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("GoToCitiesEditor"), object: nil)
            case 1:
                print("settings cell was tapped")
                
                NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name("GoToSettings"), object: nil)
            default:
                break
            }
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cities.count
        case 1:
            return sideMenuSettings.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as? SideMenuTableViewCell else {
                print("reusing cells failed")
                return UITableViewCell()
            }
            let city = cities[indexPath.row]
            cell.cityNameLabel.text = city.value(forKey: "name") as? String
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as? SideMenuTableViewCell else {
                print("reusing cells failed")
                return UITableViewCell()
            }
            cell.settingsNameLabel.text = sideMenuSettings[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
