//
//  CityManager.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit
import CoreLocation

class CityManager: NSObject {

    typealias SuccessHandler = (_ json : [[String : Any]]) -> Void
    typealias FailureHandler = (_ error : String) -> Void
    
    static func getForecastFor(cityID : Int, success : @escaping SuccessHandler , failure : @escaping FailureHandler) {
        
        getWeatherFor(cityID: cityID, isWeather: false, success: success, failure: failure)
    }
    
    static func getWeatherFor(cityID : Int, isWeather : Bool, success : @escaping SuccessHandler , failure : @escaping FailureHandler) {
        
        let APIKey = "f435bd228edc1bf4e4009e5fc7d3e621"
        var urlString = ""
        if !isWeather {
             urlString = "http://api.openweathermap.org/data/2.5/forecast?id=\(cityID)&APPID=" + APIKey
        }
        else {
            urlString = "http://api.openweathermap.org/data/2.5/weather?id=\(cityID)&APPID=" + APIKey
        }
        let url = URL.init(string: urlString)
        let urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
                    DispatchQueue.main.async {
                        if !isWeather {
                            success(json["list"] as! [[String : Any]])
                        }
                        else {
                            success([json])
                        }
                    }
                }
                catch {
                }
            }
            else {
                DispatchQueue.main.async {
                    failure((error?.localizedDescription)!)
                }
            }
        }
        task.resume()
    }
    
    static func getCitiesFromLocalJson(cityName : String) -> [City]{
        
        let citiesJson = CityManager.readJson()
        let cities = parsedCities(citiesJson: citiesJson)
        return filterCitiesWith(cityName: cityName, cities: cities)
    }
    
    static func getCitiesFromLocalJson(by cityLocation : CLLocation) -> City{
        let citiesJson = CityManager.readJson()
        let cities = parsedCities(citiesJson: citiesJson)
        for city in cities {
            if city.cityCoord.lat == cityLocation.coordinate.latitude && city.cityCoord.lon == cityLocation.coordinate.longitude {
                return city
            }
        }
        let london = City()
        /*
         "id": 2643741,
         "name": "City of London",
         "country": "GB",
         "coord": {
         "lon": -0.09184,
         "lat": 51.512791
         }*/
        london.cityID =  2643741
        london.cityName = "City of London"
        london.cityCountry = "GB"
        return london
    }
    
    private static func filterCitiesWith(cityName : String, cities : [City]) -> [City] {
    
        var result = [City]()
        for city in cities {
            if city.cityName.lowercased().contains(cityName.lowercased()) {
                result.append(city)
            }
        }
        return result
    }
    
    private static func parsedCities(citiesJson : [[String : Any]]) -> [City]{
        var allCities = [City]()
        for cityJson in citiesJson {
            let city = City(with: cityJson)
            allCities.append(city)
        }
        return allCities
    }
    
    private static func readJson() -> [[String : Any]] {
        do {
            if let file = Bundle.main.url(forResource: "city", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [[String: Any]] {
                    // json is an array
                    return object
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
            
        }
        return []
    }
}
