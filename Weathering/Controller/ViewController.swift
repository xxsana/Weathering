//
//  ViewController.swift
//  Weathering
//
//  Created by Haru on 2021/10/06.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hourlyTableView: UITableView!
    
    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var hourly = [WeatherDetail]()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        
        setButtonImage()
        
        getCurrentLocation()
    }
    

    // MARK: - IBActions

    // call when click search button
    @IBAction func searchClicked(_ sender: UIButton) {
        
        if cityTextField.text?.isEmpty ?? true {
            print("DEBUG: no text in textfield")
        } else {
            if let city = cityTextField.text {
                self.fetchWeatherAndSet(with: city)
                
                cityTextField.text = ""
                cityTextField.resignFirstResponder()
            }
        }
    }
    
    // call when click current location button
    @IBAction func currentLocationClicked(_ sender: Any) {
        getCurrentLocation()
    }
    
    // MARK: - Helpers
    func setDelegate() {
        cityTextField.delegate = self
        hourlyTableView.delegate = self
        hourlyTableView.dataSource = self
        weatherManager.delegate = self
        locationManager.delegate = self
    }
    
    func setButtonImage() {
        let cImage = UIImage(systemName: "location.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 26))
        currentButton.setImage(cImage, for: .normal)
        
        let sImage = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 26))
        searchButton.setImage(sImage, for: .normal)
    }

    func fetchWeatherAndSet(with city: String) {
        // update label and fetch data
        setCityLabel(as: city)
        weatherManager.fetchData(in: city)
    }
    
    func getCurrentLocation() {
        // ask user using of gps
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    // update location label
    func setCityLabel(as city: String) {
        self.cityLabel.text = city
    }
}

// MARK: - delegate for WeatherManager
extension ViewController: WeatherManagerDelegate {
    func setWeather(weather: WeatherModel) {
        
        hourly = weather.hourly
        
        // current weather
        temperatureLabel.text = "\(weather.current.temp)℃"
        conditionImageView.image = UIImage(systemName: weather.current.condition, withConfiguration: UIImage.SymbolConfiguration(pointSize: 120))
        
        // hourly weather
        hourlyTableView.reloadData()
    }
}

// MARK: - delegate for UITableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // update after resizing
        return hourly.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyTableViewCell", for: indexPath) as? HourlyTableViewCell {
            let hour = indexPath.row + 1
            cell.setWeather(index: hour, with: hourly[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - delegate for get current location
extension ViewController: CLLocationManagerDelegate {
    
    // is called when CLLocation get location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            
            // get city name with coordination info and update city label as completionTask.
            weatherManager.getCityName(for: location) { city in
                self.setCityLabel(as: city)
            }
            weatherManager.fetchDataWithCoordi(with: location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: fail to get current location with error")
        print("DEBUG: \(error.localizedDescription)")
    }
    
}

// MARK: - delegate for textfield
extension ViewController: UITextFieldDelegate {
    
    // when click return in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text?.isEmpty ?? true {
            print("DEBUG: no text in textfield")
        } else {
            if let city = cityTextField.text {
                self.fetchWeatherAndSet(with: city)
                
                cityTextField.text = ""
                cityTextField.resignFirstResponder()
            }
        }
        return true
    }
}
