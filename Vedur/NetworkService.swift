//
//  NetworkService.swift
//  Vedur
//
//  Created by Alex Kagarov on 6/27/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import Foundation

enum DataManagerError: Error {
    case Unknown
    case FailedRequest
    case InvalidResponse
}

class NetworkService: NSObject {
    static let sharedInstance = NetworkService()
    private override init() {}
    
    func getWeatherDataWith(city: City, completion: @escaping ((Weather) -> Void)) {
        let urlDomain = "https://api.openweathermap.org/data/2.5/weather?"
        let coordinates = "lat=\(city.lat)&lon=\(city.lon)"
        let apiKey = "&appid=c5a8237d625db396b430d87be0914060"
        let weatherUrlString = urlDomain + coordinates + apiKey
        
        guard let url = URL(string: weatherUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        let newWeather = Weather(entity: weatherEntity, insertInto: managedContext)
                        
                        let weatherArray = json["weather"] as? [Any]
                        let weather = weatherArray?[0] as? [String:Any]
                        let weatherDescription = weather?["main"] as? String
                        newWeather.weatherDescription = weatherDescription ?? ""
                        
                        let main = json["main"] as? [String:Any]
                        let temp = main?["temp"] as? Double
                        let tempMin = main?["temp_min"] as? Double
                        let tempMax = main?["temp_max"] as? Double
                        let humidity = main?["humidity"] as? Double
                        let pressure = main?["pressure"] as? Double
                        newWeather.temp = temp ?? 0
                        newWeather.tempMin = tempMin ?? 0
                        newWeather.tempMax = tempMax ?? 0
                        newWeather.humidity = humidity ?? 0
                        newWeather.pressure = pressure ?? 0
                        
                        let wind = json["wind"] as? [String:Any]
                        let windSpeed = wind?["speed"] as? Double
                        let windDegree = wind?["deg"] as? Double
                        newWeather.windSpeed = windSpeed ?? 0
                        newWeather.windDegree = windDegree ?? 0
                        
                        let cloudsDict = json["clouds"] as? [String:Any]
                        let clouds = cloudsDict?["all"] as? Double
                        newWeather.clouds = clouds ?? 0
                        
                        let sys = json["sys"] as? [String:Any]
                        let sunrise = sys?["sunrise"] as? Double
                        let sunset = sys?["sunset"] as? Double
                        newWeather.sunrise = sunrise ?? 0
                        newWeather.sunset = sunset ?? 0
                        
                        let dateTime = json["dt"] as? Double
                        newWeather.dateTime = dateTime ?? 0
                        
                        newWeather.city = city
                        
                        NotificationCenter.default.post(name: NSNotification.Name("UpdateCollection"), object: nil)
                        NotificationCenter.default.post(name: NSNotification.Name("UpdateTable"), object: nil)
                        
                        completion(newWeather)
                    }
                }
            } catch let error {
                print(error)
            }
            }.resume()
    }
    
    func getForecastDataWith(city: City, completion: @escaping (Forecast) -> Void) {
        let urlDomain = "https://api.openweathermap.org/data/2.5/forecast?"
        let coordinates = "lat=\(city.lat)&lon=\(city.lon)"
        let apiKey = "&appid=c5a8237d625db396b430d87be0914060"
        let forecastUrlString = urlDomain + coordinates + apiKey
        
        guard let url = URL(string: forecastUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // guard error == nil else { return }
            guard let data = data else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    DispatchQueue.main.async {
                        let forecastArray = json["list"] as? [[String:Any]]
                        
                        for forecast in forecastArray! {
                            let newForecast = Forecast(entity: forecastEntity, insertInto: managedContext)
                            
                            let dateTime = forecast["dt"] as? Double
                            newForecast.dateTime = dateTime ?? 0
                            
                            let weatherArray = forecast["weather"] as? [[String:Any]]
                            let weatherArrayElt = weatherArray?[0]
                            let forecastDescription = weatherArrayElt?["main"] as? String
                            newForecast.forecastDescription = forecastDescription ?? ""
                            
                            let main = forecast["main"] as? [String:Any]
                            let temp = main?["temp"] as? Double
                            let tempMin = main?["temp_min"] as? Double
                            let tempMax = main?["temp_max"] as? Double
                            
                            newForecast.temp = temp ?? 0
                            newForecast.tempMin = tempMin ?? 0
                            newForecast.tempMax = tempMax ?? 0
                            
                            newForecast.city = city
                            
                            NotificationCenter.default.post(name: NSNotification.Name("UpdateCollection"), object: nil)
                            NotificationCenter.default.post(name: NSNotification.Name("UpdateTable"), object: nil)
                            
                            completion(newForecast)
                        }
                    }
                }
            } catch let error {
                print(error)
            }
            }.resume()
    }
}
