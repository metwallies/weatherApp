//
//  CityDetailedForecastViewController.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit

class CityDetailedForecastViewController: UIViewController {

    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelCountryName: UILabel!
    @IBOutlet weak var tableViewForecast: UITableView!
    var selectedCity = City()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelCityName.text = selectedCity.cityName
        self.labelCountryName.text = selectedCity.cityCountry
        getForecast()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getForecast() {
        CityManager.getForecastFor(cityID: selectedCity.cityID, success: { (json) in
            for dict in json {
                let weather = Weather(with: dict)
                self.selectedCity.weather.append(weather)
            }
            self.selectedCity.filterWeather()
            
        }) { (error) in
            
        }
    }
    
    @IBAction func backButtonDidTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
