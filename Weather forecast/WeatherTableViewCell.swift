//
//  WeatherTableViewCell.swift
//  Weather forecast
//
//  Created by islam metwally on 2/25/18.
//  Copyright © 2018 Islam Metwally. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var waetherDescriptionLabel: UILabel!
    @IBOutlet weak var maxDegreeLabel: UILabel!
    @IBOutlet weak var minDegreeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(with weather : Weather) {
        waetherDescriptionLabel.text = weather.weatherDescription
        let maxDegree = String(format: "%.02f", weather.maxDegree)
        let minDegree = String(format: "%.02f", weather.minDegree)
        maxDegreeLabel.text = "max: \(maxDegree) C˚"
        minDegreeLabel.text = "min: \(minDegree) C˚"
        dateLabel.text = weather.date
    }
}
