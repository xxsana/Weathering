//
//  ViewController.swift
//  Weathering
//
//  Created by Haru on 2021/10/06.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hourlyTableView: UITableView!
    
    let manager = WeatherManager()
    var hourly = [WeatherDetail]()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        
        setButtonImage()
        
    }
    

    // MARK: - IBActions
    
    @IBAction func searchClicked(_ sender: UIButton) {
        guard let city = cityTextField.text else { print("DEBUG: no text in textfield"); return }
        
        manager.fetchData(city)
        
        cityTextField.text = ""
        cityTextField.resignFirstResponder()
        
        // set location label
        self.locationLabel.text = city
    }
    
    
    // MARK: - Helpers
    func setDelegate() {
        cityTextField.delegate = self
        hourlyTableView.delegate = self
        hourlyTableView.dataSource = self
        manager.delegate = self
    }
    
    func setButtonImage() {
        let cImage = UIImage(systemName: "location.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 26))
        currentButton.setImage(cImage, for: .normal)
        
        let sImage = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 26))
        searchButton.setImage(sImage, for: .normal)
    }

}

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

extension ViewController: UITextFieldDelegate {
    
    // when click return in keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let city = textField.text else {
            print("DEBUG: no text in textfield")
            return true
        }
        manager.fetchData(city)

        textField.text = ""
        textField.resignFirstResponder()
        
        // set location label
        self.locationLabel.text = city
        
        return true
    }
}
