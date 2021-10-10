//
//  HourlyTableViewCell.swift
//  Weathering
//
//  Created by Haru on 2021/10/10.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
   
    func setWeather(index: Int, with weather: WeatherDetail) {
        self.backgroundColor = UIColor.clear
        hourLabel.text = "+ \(index)hour"
        conditionImageView.image = UIImage(systemName: weather.condition)
        temperatureLabel.text = "\(weather.temp)℃"
    }

}
