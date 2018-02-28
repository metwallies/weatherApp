//
//  HomeCitiesTableViewCell.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit

class HomeCitiesTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var tempDegree: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCellWithCity(city : City) {
        labelCityName.text = city.cityName
        let maxDegree = String(format: "%.02f", city.weather.maxDegree)
        tempDegree.text = "temp: \(maxDegree) C˚"
    }
}
