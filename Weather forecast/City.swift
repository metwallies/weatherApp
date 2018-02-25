//
//  City.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit

/*
 {
 "id": 707860,
 "name": "Hurzuf",
 "country": "UA",
 "coord": {
 "lon": 34.283333,
 "lat": 44.549999
 }
 }
 */

class City: NSObject {

    var cityID : Int = 0
    var cityName : String = ""
    var cityCountry : String = ""
    
    struct Coord {
        var lon : Double = 0.0
        var lat : Double = 0.0
    }
    var cityCoord : Coord = Coord(lon: 0, lat: 0)
    var weather = [Weather]()
    
    override init() {
        super.init()
    }
    
    init(with json : [String : Any]) {
        cityID = json["id"] as! Int
        cityName = json["name"] as! String
        cityCountry = json["country"] as! String
        let coord = json["coord"] as! [String : Any]
        cityCoord.lon = coord["lon"] as! Double
        cityCoord.lat = coord["lat"] as! Double
    }
    
    func filterWeather() {
        var tempWeather = [Weather]()
        for weath in weather {
            if !tempWeather.contains(weath) {
                var distnct = true
                for tempWeath in tempWeather {
                    if tempWeath.date == weath.date {
                        distnct = false
                    }
                }
                if distnct {
                    tempWeather.append(weath)
                }
            }
        }
        weather = tempWeather
    }
}
