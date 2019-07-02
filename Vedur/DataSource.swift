//
//  DataSource.swift
//  Vedur
//
//  Created by Alex Kagarov on 6/23/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit
import Foundation
import CoreData

var forecasts = [Forecast]()
var cities = [City]()
var weathers = [Weather]()
let defaults = UserDefaults.standard

let managedContext = CoreDataStack.persistentContainer.viewContext
let cityEntity = NSEntityDescription.entity(forEntityName: "City", in: managedContext)!
let weatherEntity = NSEntityDescription.entity(forEntityName: "Weather", in: managedContext)!
let forecastEntity = NSEntityDescription.entity(forEntityName: "Forecast", in: managedContext)!

func addCityWeatherAndForecast(_ city: City) {
    NetworkService.sharedInstance.getWeatherDataWith(city: city, completion: { weather in
        print("Weather for \(city.name ?? "") received from server. \(weather)")
    })
    NetworkService.sharedInstance.getForecastDataWith(city: city, completion: { forecast in
        print("Forecast for \(city.name ?? "") received from server. \(forecast)")
    })
}

func addCity(name: String, lat: Double, lon: Double) {
    let newCity = City(entity: cityEntity, insertInto: managedContext)
    
    newCity.name = name
    newCity.lat = lat
    newCity.lon = lon
    
    let lastCityId = defaults.integer(forKey: "LastCityId")
    
    newCity.id = Int64(lastCityId+1)
    
    defaults.set(newCity.id, forKey: "LastCityId")
    
    print("Added new city \(newCity.name ?? ""): [id=\(newCity.id), coord=(\(newCity.lat);\((newCity.lon))]")
    
    addCityWeatherAndForecast(newCity)
    
    saveCity(newCity)
}

func getDataFromServer() {
    clearForecasts()
    for city in cities {
        addCityWeatherAndForecast(city)
    }
}

func saveCity(_ newCity: City) {
    do {
        try managedContext.save()
        cities.append(newCity)
    } catch let error as NSError {
        print("Can't save city. \(error), \(error.userInfo)")
    }
}

func addCurrentLocation() {
    guard let lat = (LocationManager.shared.location?.coordinate.latitude) else {return}
    guard let lon = (LocationManager.shared.location?.coordinate.longitude) else {return}
    addCity(name: "Current location", lat: lat, lon: lon)
}

func clearForecasts() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Forecast")
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
        try managedContext.execute(batchDeleteRequest)
        
    } catch {
        print(error)
    }
}

func removeCurrentLocation() {
    let name = "Current location"
    let fetchRequest = NSFetchRequest<City>(entityName: "City")
    fetchRequest.predicate = NSPredicate.init(format: "name==\"\(name)\"")
    
    if let result = try? managedContext.fetch(fetchRequest) {
        for object in result {
            managedContext.delete(object)
        }
    }
    
    do {
        try managedContext.save()
    }
    catch {
        print(error)
    }
}

func prePopulate() {
    fetchCityData()
    if cities.count == 0 {
        addCurrentLocation()
        addCity(name: "Kyiv", lat: 50.4501, lon: 30.5234)
        addCity(name: "Odessa", lat: 46.4825, lon: 30.7233)
    }
}

func fetchCityData() {
    let fetchRequest = NSFetchRequest<City>(entityName: "City")
    let idSort = NSSortDescriptor(key: "id", ascending: true)
    fetchRequest.sortDescriptors = [idSort]
    do {
        cities = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch cities. \(error), \(error.userInfo)")
    }
}

func fetchWeatherData() {
    let fetchRequest = NSFetchRequest<Weather>(entityName: "Weather")
    do {
        weathers = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch weathers. \(error), \(error.userInfo)")
    }
}

func fetchForecastData() {
    let fetchRequest = NSFetchRequest<Forecast>(entityName: "Forecast")
    do {
        forecasts = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch forecasts. \(error), \(error.userInfo)")
    }
}
