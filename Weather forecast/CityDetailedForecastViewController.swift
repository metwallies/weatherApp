//
//  CityDetailedForecastViewController.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit
import RealmSwift

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
        tableViewForecast.tableFooterView = UIView()
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
            DispatchQueue.main.async {
                
                self.tableViewForecast.reloadData()
            }
        }) { (error) in
            //TODO: handle error.
        }
    }
    
    @IBAction func backButtonDidTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func addCityToFavorite(_ sender: Any) {
        let realm = try! Realm()
        let city = selectedCity
        try! realm.write {
            realm.add(city)
        }
    }
}

extension CityDetailedForecastViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherTableViewCell
        
        cell.setupCell(with: selectedCity.weather[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCity.weather.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
