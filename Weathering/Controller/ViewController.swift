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
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hourlyTableView: UITableView!
    
    let manager = WeatherManager()
    
    
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
    }
    
    
    // MARK: - Helpers
    func setDelegate() {
        cityTextField.delegate = self
    }
    
    func setButtonImage() {
        let cImage = UIImage(systemName: "location.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 26))
        currentButton.setImage(cImage, for: .normal)
        
        let sImage = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 26))
        searchButton.setImage(sImage, for: .normal)
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
        
        return true
    }
}
