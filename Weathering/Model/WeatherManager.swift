//
//  WeatherManager.swift
//  Weathering
//
//  Created by Haru on 2021/10/06.
//

import Foundation
import CoreLocation

// MARK: - Protocol
protocol WeatherManagerDelegate {
    func setWeather(weather: WeatherModel)
}

class WeatherManager {
    
    // MARK: - Properties
    var delegate: WeatherManagerDelegate?
    
    // my api id
    let key = "18a8b6952c0a12293ab5c0b4ccfcfbe3"

    
    // MARK: - API
    
    // when click search or return in text field
    func fetchData(in city: String) {
        // get coordinate from city name by CoreLocation
        getCoordinate(city) { coordi in
            self.fetchDataWithCoordi(with: coordi)
        }
    }
    
    // when open app and get location information
    func fetchDataWithCoordi(with coordi: CLLocationCoordinate2D) {
        
        let lat = coordi.latitude
        let lon = coordi.longitude
        
        // set urlString
        let http =
            "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,daily&units=metric&appid=18a8b6952c0a12293ab5c0b4ccfcfbe3"
        
        let urlString = "\(http)&appid=\(self.key)"
        
        // Call current & hourly weather data from lan, lon
        self.performRequest(urlString)
    }
    
    
    // do dataTask with given url
    func performRequest(_ urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        let urlSession = URLSession(configuration: .default)
        let dataTask = urlSession.dataTask(with: url) { data, urlResponse, error in
            if let e = error {
                print("DEBUG: \(e.localizedDescription)")
                return
            }
            // successfully got data
            if let safeData = data {
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
            
            let weather = setWeatherModel(data: decodedData)
            
            // update UI in controller
            DispatchQueue.main.async {
                self.delegate?.setWeather(weather: weather)
            }
        } catch {
            print("DEBUG: error during parseJSON")
        }
    }
    
    // MARK: - Helpers
    
    // get coordinate information from city name using CLGeocoder
    func getCoordinate(_ city: String, completionTask: @escaping (_ coordi: CLLocationCoordinate2D) -> ()) -> Void {

        let geoCoder = CLGeocoder()
        var coordinate = CLLocationCoordinate2D()

        geoCoder.geocodeAddressString(city) { (placemarks, error) in
            if let e = error {
                print("DEBUG: error in getCoordinate")
                print("DEBUG: \(e.localizedDescription)")
                return
            }
            // no error
            if let placemarks = placemarks,
               let location = placemarks.first?.location {
                coordinate.latitude = location.coordinate.latitude
                coordinate.longitude = location.coordinate.longitude
                
                completionTask(coordinate)
            }
        }
    }
    
    // get city name from coordination using CLGeocoder
    func getCityName(for location: CLLocation, completionTask: @escaping (_ city: String) -> ()) -> () {
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if let e  = error {
                print("DEBUG: error in getCoordinate")
                print("DEBUG: \(e.localizedDescription)")
                return
            }
            // no error
            if let placemark = placemarks?[0], let city = placemark.administrativeArea {
                // update city label in controller
                completionTask(city)
            }
        }
    }

    // convert decoded data to model struct
    func setWeatherModel(data: WeatherData) -> WeatherModel {
        
        // set current weather
        let currentTemp = round(data.current.temp*10)/10
        let currentID = data.current.weather[0].id
        let current = WeatherDetail(temp: currentTemp, conditionID: currentID)
        
        // set hourly weather
        var hourly = [WeatherDetail]()
        
        // get current time
        let date = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: date)
        
        for i in 0..<9 {
            let temp = round(data.hourly[i].temp*10)/10
            let time = currentHour + i + 1
            let hour = WeatherDetail(temp: temp, conditionID: data.hourly[i].weather[0].id, time: time)
            hourly.append(hour)
        }
        
        let weather = WeatherModel(current: current, hourly: hourly)
        return weather
    }
}
