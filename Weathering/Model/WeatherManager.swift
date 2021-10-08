//
//  WeatherManager.swift
//  Weathering
//
//  Created by Haru on 2021/10/06.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func setWeather(weather: WeatherModel)
}

class WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    // my api id
    let key = "18a8b6952c0a12293ab5c0b4ccfcfbe3"

    // when click search or return in text field
    func fetchData(_ city: String) {
        
        // get coordinate from city name by CoreLocation
        let coordinate = getCoordinate(city)
//        let lat = coordinate.latitude
//        let lon = coordinate.longitude
        
        let lat = 35.1028
        let lon = 129.0403
        print("DEBUG: city: \(city)")
        print("DEBUG: lat, lon in fetchData: \(lat), \(lon)")
        
        // set urlString
        let http =
            "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,daily&units=metric&appid=18a8b6952c0a12293ab5c0b4ccfcfbe3"
        
        let urlString = "\(http)&appid=\(key)"
        
        // Call current & hourly weather data from lan, lon
        performRequest(urlString)
    }
    
    
    // do dataTask with given url
    func performRequest(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        let urlSession = URLSession(configuration: .default)
        let dataTask = urlSession.dataTask(with: url) { data, urlResponse, error in
            if let e = error {
                print("DEBUG: \(e.localizedDescription)")
                return
            }
            // successfully get data
            if let safeData = data {
                print("DEBUG: successfully got data")
                self.parseJSON(safeData)
            }
        }
        dataTask.resume()
    }
    
    
    // decode data into JSON
    func parseJSON(_ data: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            print("DEBUG: Current weather: \(decodedData.current.temp)")
            
//            let current = decodedData.current
            let weather = setWeatherModel(data: decodedData)
            
            DispatchQueue.main.async {
                self.delegate?.setWeather(weather: weather)
            }
            
//            print("DEBUG: Current: \(weather.current.temp)")
//            print("DEBUG: Condition: \(weather.current.condition)")
        
        } catch {
            print("DEBUG: error during parseJSON")
        }
    }
    
    // get coordinate information from city name
    func getCoordinate(_ city: String) -> CLLocationCoordinate2D {
        
        let geoCoder = CLGeocoder()
        var coordinate = CLLocationCoordinate2D()
        
        geoCoder.geocodeAddressString(city) { (placemarks, error) in
            if let e = error {
                print("DEBUG: error in getCoordinate")
                print("DEBUG: \(e.localizedDescription)")
                return
            }
            if let placemarks = placemarks,
               let location = placemarks.first?.location {
                coordinate.latitude = location.coordinate.latitude
                coordinate.longitude = location.coordinate.longitude
            }
        }
        return coordinate
    }
    
    // convert decoded data to model struct
    func setWeatherModel(data: WeatherData) -> WeatherModel {
        
        let currentTemp = data.current.temp
        let currentID = data.current.weather[0].id
        let current = WeatherDetail(temp: currentTemp, conditionID: currentID)
        
        var hourly = [WeatherDetail]()
        
        for i in 0..<5 {
            let hour = WeatherDetail(temp: data.hourly[i].temp, conditionID: data.hourly[i].weather[0].id)
            
            hourly.append(hour)
        }
        
        let weather = WeatherModel(current: current, hourly: hourly)
        return weather
    }
}
