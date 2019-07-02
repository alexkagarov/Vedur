//
//  ForecastTableViewCell.swift
//  Vedur
//
//  Created by Alex Kagarov on 7/1/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minForecastTemp: UILabel!
    @IBOutlet weak var maxForecastTemp: UILabel!
    @IBOutlet weak var forecastImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
