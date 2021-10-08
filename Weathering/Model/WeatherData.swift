//
//  WeatherData.swift
//  Weathering
//
//  Created by Haru on 2021/10/09.
//

import Foundation

// class for JSON structure
struct WeatherData: Decodable {
    let current: Current
    let hourly: [Hourly]
}

struct Current: Decodable {
    let temp: Double
    let weather: [Weather]
}

struct Hourly: Decodable {
    let temp: Double
    let weather: [Weather]
}

struct Weather: Decodable {
    let id: Int
}
