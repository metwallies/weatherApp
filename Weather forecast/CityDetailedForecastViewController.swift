//
//  CityDetailedForecastViewController.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit
import RealmSwift

protocol CityDetailForecastDelegate: AnyObject {
    func didAddCityToFavorites(_ city : City)
}

class CityDetailedForecastViewController: UIViewController {

    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelCountryName: UILabel!
    @IBOutlet weak var tableViewForecast: UITableView!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    weak var delegate : CityDetailForecastDelegate?
    var selectedCity = City()
    var isCityFavored = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelCityName.text = selectedCity.cityName
        self.labelCountryName.text = selectedCity.cityCountry
        getForecast()
        tableViewForecast.tableFooterView = UIView()
        
        addToFavoritesButton.isHidden = isCityFavored
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getForecast() {
        CityManager.getForecastFor(cityID: selectedCity.cityID, success: { (json) in
            let list = json[0]["list"] as! [[String : Any]]
            for dict in list {
                let weather = Weather(with: dict)
                let cityJson = json[0]["city"] as! [String : Any]
                weather.cityID = cityJson["id"] as! Int
                self.selectedCity.forecast.append(weather)
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
            realm.add(city.forecast)
            realm.add(city.weather)
        }
        if delegate != nil {
            delegate?.didAddCityToFavorites(selectedCity)
        }
    }
}

extension CityDetailedForecastViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherTableViewCell
        
        cell.setupCell(with: selectedCity.forecast[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCity.forecast.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
