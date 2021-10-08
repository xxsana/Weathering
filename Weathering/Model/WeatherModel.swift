//
//  WeatherModel.swift
//  Weathering
//
//  Created by Haru on 2021/10/09.
//

import Foundation

struct WeatherModel {
    let current: WeatherDetail
    let hourly: [WeatherDetail]
}

struct WeatherDetail {
    var temp: Double
    var conditionID: Int
    
    var condition: String {
        switch conditionID {
        case 200..<300:
            return "cloud.bolt"
        case 300..<400:
            return "cloud.drizzle"
        case 500..<600:
            return "cloud.rain"
        case 600..<700:
            return "cloud.snow"
        case 700...711:
            return "smoke"
        case 712..<800:
            return "cloud.fog"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
}
