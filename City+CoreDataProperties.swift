//
//  City+CoreDataProperties.swift
//  
//
//  Created by Alex Kagarov on 6/30/19.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var forecast: NSOrderedSet?
    @NSManaged public var weather: Weather?

}

// MARK: Generated accessors for forecast
extension City {

    @objc(insertObject:inForecastAtIndex:)
    @NSManaged public func insertIntoForecast(_ value: Forecast, at idx: Int)

    @objc(removeObjectFromForecastAtIndex:)
    @NSManaged public func removeFromForecast(at idx: Int)

    @objc(insertForecast:atIndexes:)
    @NSManaged public func insertIntoForecast(_ values: [Forecast], at indexes: NSIndexSet)

    @objc(removeForecastAtIndexes:)
    @NSManaged public func removeFromForecast(at indexes: NSIndexSet)

    @objc(replaceObjectInForecastAtIndex:withObject:)
    @NSManaged public func replaceForecast(at idx: Int, with value: Forecast)

    @objc(replaceForecastAtIndexes:withForecast:)
    @NSManaged public func replaceForecast(at indexes: NSIndexSet, with values: [Forecast])

    @objc(addForecastObject:)
    @NSManaged public func addToForecast(_ value: Forecast)

    @objc(removeForecastObject:)
    @NSManaged public func removeFromForecast(_ value: Forecast)

    @objc(addForecast:)
    @NSManaged public func addToForecast(_ values: NSOrderedSet)

    @objc(removeForecast:)
    @NSManaged public func removeFromForecast(_ values: NSOrderedSet)

}
