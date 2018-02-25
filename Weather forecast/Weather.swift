//
//  Weather.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit

class Weather: NSObject {

    var date = ""
    var minDegree = 0.0
    var maxDegree = 0.0
    var weatherDescription = ""
    
    override init() {
        super.init()
    }
    
    init(with json : [String : Any]) {
        let tempDate = json["dt_txt"] as! String
        let index = tempDate.index(tempDate.startIndex, offsetBy: 10)
        date = "\(tempDate[..<index])"
        let main = json["main"] as! [String : Any]
        minDegree = main["temp_min"] as! Double
        maxDegree = main["temp_max"] as! Double
        let weather = json["weather"] as! [[String : Any]]
        weatherDescription = weather[0]["description"] as! String
    }
}