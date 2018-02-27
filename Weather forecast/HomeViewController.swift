//
//  ViewController.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var tableViewFavoriteCities: UITableView!
    @IBOutlet weak var tableViewSearchCities: UITableView!
    var arrayFavoriteCities = [City]()
    var arraySearchCities = [City]()
    let minimumSearchText = 3
    let londonID = 2643741
    var locationManager = CLLocationManager()
    var userCity = City()
    var userLocation = CLLocation()
    var isUserLocationUpdated = false
    var detailsVC : CityDetailedForecastViewController!
    @IBOutlet weak var searchBarCities: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.tableViewFavoriteCities.tableFooterView = UIView()
        //TODO: load data offline
        attachWeatherToCity()
    }
    
    private func attachWeatherToCity() {
        let realm = try! Realm()
        let realmCity = realm.objects(City.self)
        let realmForecast = realm.objects(Weather.self)
        
        for city in realmCity {
            var weatherFound = false
            for weather in realmForecast {
                if weather.cityID == city.cityID {
                    if weather.date != nil {
                        city.forecast.append(weather)
                    }
                    else {
                        city.weather = weather
                        weatherFound = true
                        arrayFavoriteCities.append(city)
                    }
                }
            }
            if !weatherFound {
                CityManager.getWeatherFor(cityID: city.cityID, isWeather: true, success: { (json) in
                    city.weather = Weather(with: json[0])
                    try! realm.write {
                        realm.add(city.weather)
                    }
                    self.arrayFavoriteCities.append(city)
                    self.tableViewFavoriteCities.reloadData()
                }, failure: { (error) in
                    self.showError(message: error)
                })
            }
        }
        tableViewFavoriteCities.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Internal
    func requestWeather(cityID : Int) {
        CityManager.getWeatherFor(cityID: cityID, isWeather: true, success: {[unowned self] (json) in
            let weatherJson = json[0]
            let weather = Weather(with: weatherJson)
            self.userCity.weather = weather
            self.arrayFavoriteCities.append(self.userCity)
            let realm = try! Realm()
            try! realm.write {
                realm.add(self.userCity)
                realm.add(weather)
            }
            self.tableViewFavoriteCities.reloadData()
        }) {[unowned self] (error) in
            self.showError(message: error)
        }
    }
    
}

extension HomeViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isUserLocationUpdated {
            isUserLocationUpdated = true
            userLocation = locations.last!
            userCity = CityManager.getCitiesFromLocalJson(by: userLocation)
            requestWeather(cityID: userCity.cityID)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
                switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways:
                    locationManager.startUpdatingLocation()
                    break
                case .authorizedWhenInUse :
                    locationManager.startUpdatingLocation()
                    break
                default:
                    let london = City()
                    london.cityID =  2643741
                    london.cityName = "City of London"
                    london.cityCountry = "GB"
                    userCity = london
                    requestWeather(cityID: londonID)
                    break
                }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let cityName = searchBar.text
        if (cityName?.count)! > minimumSearchText {
            tableViewSearchCities.isHidden = false
            DispatchQueue.global(qos: .userInitiated).async {
                self.arraySearchCities = CityManager.getCitiesFromLocalJson(cityName: cityName!)
                DispatchQueue.main.async {
                    self.tableViewSearchCities.reloadData()
                }
            }
        }
        else if searchText == "" {
            tableViewSearchCities.isHidden = true
            searchBar.resignFirstResponder()
            arraySearchCities.removeAll()
            tableViewSearchCities.reloadData()
        }
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, CityDetailForecastDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewFavoriteCities {
            return arrayFavoriteCities.count
        }
        return arraySearchCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewSearchCities {
            let cell = tableView.dequeueReusableCell(withIdentifier: "search cell")
            if arraySearchCities.count > indexPath.row {
                let tempCity = arraySearchCities[indexPath.row]
                cell?.textLabel?.text = tempCity.cityName
                cell?.detailTextLabel?.text = tempCity.cityCountry
            }
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HomeCitiesTableViewCell
            cell.setCellWithCity(city: arrayFavoriteCities[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "details") as! CityDetailedForecastViewController
        detailsVC.delegate = self
        if tableView == tableViewSearchCities {
            detailsVC.selectedCity = arraySearchCities[indexPath.row]
            for tempCity in arrayFavoriteCities {
                if arraySearchCities[indexPath.row].cityID == tempCity.cityID {
                    detailsVC.isCityFavored = true
                }
            }
        }
        else {
            detailsVC.selectedCity = arrayFavoriteCities[indexPath.row]
            detailsVC.isCityFavored = true
        }
        self.show(detailsVC, sender: self)
    }
    
    func didAddCityToFavorites(_ city: City) {
        arrayFavoriteCities.append(city)
        tableViewFavoriteCities.reloadData()
    }
}

