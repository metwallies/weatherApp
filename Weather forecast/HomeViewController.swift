//
//  ViewController.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableViewFavoriteCities: UITableView!
    @IBOutlet weak var tableViewSearchCities: UITableView!
    var arrayFavoriteCities = [City]()
    var arraySearchCities = [City]()
    let minimumSearchText = 3
    @IBOutlet weak var searchBarCities: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: load data offline
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Internal
    func requestCities() {
        
        //TODO: load data online
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableViewSearchCities.isHidden = false
        let cityName = searchBar.text
        if (cityName?.count)! > minimumSearchText {
            DispatchQueue.global().async {
                self.arraySearchCities = CityManager.getCitiesFromLocalJson(cityName: cityName!)
                DispatchQueue.main.async {
                    self.tableViewSearchCities.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableViewSearchCities.isHidden = true
        arraySearchCities.removeAll()
        tableViewSearchCities.reloadData()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewFavoriteCities {
            return arrayFavoriteCities.count
        }
        return arraySearchCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewSearchCities {
            let cell = tableView.dequeueReusableCell(withIdentifier: "search cell")
            cell?.textLabel?.text = arraySearchCities[indexPath.row].cityName
            cell?.detailTextLabel?.text = arraySearchCities[indexPath.row].cityCountry
            return cell!
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "search cell")
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "details") as! CityDetailedForecastViewController
        if tableView == tableViewSearchCities {
            detailsVC.selectedCity = arraySearchCities[indexPath.row]
        }
        else {
            detailsVC.selectedCity = arrayFavoriteCities[indexPath.row]
        }
        self.show(detailsVC, sender: self)
    }
}
