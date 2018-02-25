//
//  CityManager.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit

class CityManager: NSObject {

    typealias SuccessHandler = (_ json : [[String : Any]]) -> Void
    typealias FailureHandler = (_ error : String) -> Void
    
    static func getForecastFor(cityID : Int, success : @escaping SuccessHandler , failure : @escaping FailureHandler) {
        
        let APIKey = "f435bd228edc1bf4e4009e5fc7d3e621"
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?id=\(cityID)&APPID=" + APIKey
        let url = URL.init(string: urlString)
        let urlRequest = URLRequest(url: url!)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
                    
                    success(json["list"] as! [[String : Any]])
                }
                catch {
                    
                }
            }
            else {
                failure((error?.localizedDescription)!)
            }
        }
        task.resume()
    }
    
    static func getCitiesFromLocalJson(cityName : String) -> [City]{
        
        let citiesJson = CityManager.readJson()
        let cities = parsedCities(citiesJson: citiesJson)
        return filterCitiesWith(cityName: cityName, cities: cities)
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
