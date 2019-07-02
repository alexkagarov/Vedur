//
//  TemperatureFormatter.swift
//  Vedur
//
//  Created by Alex Kagarov on 7/1/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import Foundation

func convertToCelcius(_ temp: Double) -> String {
    return (String(Int(temp-273.15)) + "°C")
}

func convertToFahrenheit(_ temp: Double) -> String {
    return (String(Int(((1.4*(temp-273.15)) + 32))) + "°F")
}

func convertToKelvin(_ temp: Double) -> String {
    return (String(Int(temp)) + "°K")
}
