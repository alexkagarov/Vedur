//
//  Forecast+CoreDataProperties.swift
//  
//
//  Created by Alex Kagarov on 6/30/19.
//
//

import Foundation
import CoreData


extension Forecast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Forecast> {
        return NSFetchRequest<Forecast>(entityName: "Forecast")
    }

    @NSManaged public var dateTime: Double
    @NSManaged public var temp: Double
    @NSManaged public var tempMax: Double
    @NSManaged public var tempMin: Double
    @NSManaged public var forecastDescription: String?
    @NSManaged public var city: City?

}
