//
//  DateFormatter.swift
//  Vedur
//
//  Created by Alex Kagarov on 7/1/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import Foundation

//for last updated
func unixToReadDate(_ date: Double) -> String {
    let formattedDate = Date(timeIntervalSince1970: date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    dateFormatter.timeStyle = DateFormatter.Style.short
    dateFormatter.timeZone = .current
    let stringDate = dateFormatter.string(from: formattedDate)
    return stringDate
}

//for
func convertToOnly24Time(_ date: Double) -> String {
    let formattedDate = Date(timeIntervalSince1970: date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let stringDate = dateFormatter.string(from: formattedDate)
    return stringDate
}

func convertTo24Time(_ date: Double) -> String {
    let formattedDate = Date(timeIntervalSince1970: date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, d MMM yyyy 'at' HH:mm"
    dateFormatter.timeZone = .current
    let stringDate = dateFormatter.string(from: formattedDate)
    return stringDate
}

func convertTo12Time(_ date: Double) -> String {
    let formattedDate = Date(timeIntervalSince1970: date)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, d MMM yyyy 'at' h:mm"
    dateFormatter.timeZone = .current
    let stringDate = dateFormatter.string(from: formattedDate)
    return stringDate
}

func returnDayFromDate(_ date: Double) -> String {
    let formattedDate = Date(timeIntervalSince1970: date)
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "EEEE"
    let stringDate = dateFormatter.string(from: formattedDate)
    return stringDate
}
