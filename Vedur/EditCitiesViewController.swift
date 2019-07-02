//
//  EditCitiesViewController.swift
//  Vedur
//
//  Created by Alex Kagarov on 6/24/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit
import CoreData

class EditCitiesViewController: UIViewController {
    
    //  OUTLETS
    @IBOutlet weak var editCitiesTableView: UITableView!
    //let managedContext = CoreDataStack.persistentContainer.viewContext
    
    @IBAction func editCitiesListIsTapped(_ sender: UIBarButtonItem) {
        self.editCitiesTableView.isEditing.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCityData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name("UpdateCollection"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("UpdateTable"), object: nil)
    }
}

extension EditCitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = cities[indexPath.row]
        let alert = UIAlertController(title: "\(selectedCity.name ?? "")", message: "City info: Name [\(selectedCity.name ?? "")]\r\n Latitude [\(selectedCity.lat)]\r\n Longitude [\(selectedCity.lon)]", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension EditCitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Current cities"
        } else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cityEditCell", for: indexPath) as? EditCityTableViewCell else {
            print("reusing cells failed")
            return UITableViewCell()
        }
        let city = cities[indexPath.item]
        cell.textLabel?.text = city.value(forKey: "name") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            fetchCityData()
            
            managedContext.delete(cities[indexPath.row])
            
            do {
                try managedContext.save()
                cities.remove(at: indexPath.row)
                self.editCitiesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            catch {
                print(error)
            }
        }
    }
}
