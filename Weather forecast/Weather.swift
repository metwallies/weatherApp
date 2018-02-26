//
//  Weather.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit

class Weather: NSObject {

    var date : String?
    var minDegree = 0.0
    var maxDegree = 0.0
    var weatherDescription = ""
    
    override init() {
        super.init()
    }
    
    init(with json : [String : Any]) {
        date = json["dt_txt"] as? String
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var dateFromDate = Date()
            if date != nil {
                dateFromDate = dateFormatter.date(from: date!)!
            }
            dateFormatter.dateFormat = "EEE, dd MM yyyy"
            date = dateFormatter.string(from: dateFromDate)
        }
        let main = json["main"] as! [String : Any]
        minDegree = main["temp_min"] as! Double
        maxDegree = main["temp_max"] as! Double
        minDegree = (minDegree - 273.15)
        maxDegree = (maxDegree - 273.15)
        let weather = json["weather"] as! [[String : Any]]
        weatherDescription = weather[0]["description"] as! String
    }
}
