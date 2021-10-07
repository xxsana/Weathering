//
//  WeatherManager.swift
//  Weathering
//
//  Created by Haru on 2021/10/06.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    let key = "18a8b6952c0a12293ab5c0b4ccfcfbe3"

    // when click search or return in text field
    func fetchData(_ city: String) {
        
        // get coordinate from city name by CoreLocation
        let coordinate = getCoordinate(city)
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        
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
    
    func parseJSON(_ data: Data) {
        print("DEBUG: parse JSON")
    }
    
    func getCoordinate(_ city: String) -> CLLocationCoordinate2D {
        
        let geoCoder = CLGeocoder()
        var coordinate = CLLocationCoordinate2D()
        
        geoCoder.geocodeAddressString(city) { (placemarks, error) in
            if let e = error {
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
}
