//
//  Weather+CoreDataProperties.swift
//  
//
//  Created by Alex Kagarov on 6/30/19.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var clouds: Double
    @NSManaged public var dateTime: Double
    @NSManaged public var humidity: Double
    @NSManaged public var pressure: Double
    @NSManaged public var sunrise: Double
    @NSManaged public var sunset: Double
    @NSManaged public var temp: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var tempMin: Double
    @NSManaged public var windDegree: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var weatherDescription: String?
    @NSManaged public var city: City?

}
