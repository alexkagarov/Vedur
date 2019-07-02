//
//  MainViewController.swift
//  Vedur
//
//  Created by Alex Kagarov on 6/22/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreData

class MainViewController: UIViewController {

    // VARS & OUTLETS
    var anyForecasts = [Any]()
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    @IBAction func onAddTapped(_ sender: UIBarButtonItem) {
        //  Google Places Autocomplete API
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // ACTIONS
    @IBAction func onSideMenuTapped(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDataFromServer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prePopulate()
        getDataFromServer()
        
        NotificationCenter.default.addObserver(self, selector:       #selector(updateCollection), name: NSNotification.Name("UpdateCollection"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:       #selector(goToCity), name: NSNotification.Name("GoToCity"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:       #selector(goToSettings), name: NSNotification.Name("GoToSettings"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:       #selector(goToCitiesEditor), name: NSNotification.Name("GoToCitiesEditor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:       #selector(moveToLastCity), name: NSNotification.Name("MoveToLastCity"), object: nil)
    }
    
    @objc func goToCity(notification: NSNotification) {
        guard let selectedCityIndex = notification.userInfo?["selectedCityIndex"] as? Int else {return}
        let selectedCityIndexPath = IndexPath(item: selectedCityIndex, section: 0)
        self.cityCollectionView.selectItem(at: selectedCityIndexPath, animated: false, scrollPosition: .left)
    }
    
    @objc func updateCollection() {
        cityCollectionView.reloadData()
    }
    
    @objc func goToSettings() {
        performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    @objc func goToCitiesEditor() {
        performSegue(withIdentifier: "showCitiesEditor", sender: nil)
    }
    
    @objc func moveToLastCity() {
        let selectedCityIndexPath = IndexPath(item: (cities.count - 1), section: 0)
        self.cityCollectionView.selectItem(at: selectedCityIndexPath, animated: false, scrollPosition: .left)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cityWeatherCell", for: indexPath) as? WeatherCollectionViewCell else {
            print("reusing cells failed")
            return UICollectionViewCell()
        }
        
        let city = cities[indexPath.item]
        
        cell.cellNameLabel.text = city.name
        cell.weatherSummary.text = city.weather?.weatherDescription
        cell.cloudsLabel.text = "Clouds: \(String(Int(city.weather?.clouds ?? 0)))%"
        cell.humidityLabel.text = "Humidity: \(String(Int(city.weather?.humidity ?? 0)))%"
        cell.pressureLabel.text = "Pressure: \(String(Int(city.weather?.pressure ?? 0)))mm"
        cell.windAngleLbl.text = "Angle: \(String(Int(city.weather?.windDegree ?? 0)))"
        cell.windSpeedLabel.text = "Speed: \(String(city.weather?.windSpeed ?? 0)) m/s"
        
        switch cell.weatherSummary.text {
        case "Clear":
            if ((city.weather!.dateTime > city.weather!.sunrise) && (city.weather!.dateTime < city.weather!.sunset)) {
                cell.weatherImage.image = UIImage(named: "sun")
            } else {
                cell.weatherImage.image = UIImage(named: "moon")
            }
        case "Rain":
            cell.weatherImage.image = UIImage(named: "rain")
        case "Clouds":
            cell.weatherImage.image = UIImage(named: "clouds")
        case "Thunderstorm":
            cell.weatherImage.image = UIImage(named: "thunderstorm")
        default:
            break
        }
        
        if let temp = city.weather?.temp {
            switch defaults.integer(forKey: "tempFormat") {
            case 0:
                cell.bigTemperature.text = convertToCelcius(temp)
            case 1:
                cell.bigTemperature.text = convertToFahrenheit(temp)
            case 2:
                cell.bigTemperature.text = convertToKelvin(temp)
            default:
                cell.bigTemperature.text = convertToCelcius(temp)
            }
        }
        
        if let dateTime = city.weather?.dateTime {
            switch defaults.integer(forKey: "timeFormat") {
            case 0:
                cell.updateTime.text = convertTo12Time(dateTime)
            case 1:
                cell.updateTime.text = convertTo24Time(dateTime)
            default:
                cell.updateTime.text = convertTo12Time(dateTime)
            }
        }
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
}

//  Google Places Autocomplete API
extension MainViewController: GMSAutocompleteViewControllerDelegate {
    func onCityTapped(selectedPlace: GMSPlace) {
        if let cityName = selectedPlace.name {
            let cityCoordLon = selectedPlace.coordinate.longitude
            let cityCoordLat = selectedPlace.coordinate.latitude
            addCity(name: cityName, lat: cityCoordLat, lon: cityCoordLon)
            
            NotificationCenter.default.post(name: NSNotification.Name("UpdateCollection"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("UpdateTable"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name("MoveToLastCity"), object: nil)
            
        } else {
            print("Empty city name. Adding unavailable")
            return
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name ?? "")")
        print("Place coordinates: \(place.coordinate.latitude);\(place.coordinate.longitude)")
        onCityTapped(selectedPlace: place)
        
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

