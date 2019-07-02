//
//  WeatherCollectionViewCell.swift
//  Vedur
//
//  Created by Alex Kagarov on 6/23/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windAngleLbl: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var cellNameLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var bigTemperature: UILabel!
    
    @IBOutlet weak var weatherSummary: UILabel!
    
    @IBOutlet weak var updateTime: UILabel!
    
    @IBOutlet weak var miniForecastCollectionView: UICollectionView!
    
    @IBOutlet weak var forecastTableView: UITableView!
    
    override func awakeFromNib() {
        
    }
    
}

extension WeatherCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as? ForecastTableViewCell else {
            print("reusing cells failed")
            return UITableViewCell()
        }
        
        cell.dayLabel.text = "Monday"
        cell.minForecastTemp.text = "+10"
        cell.maxForecastTemp.text = "+20"
        //cell.forecastImage.image
        
        return cell
    }
    
    
}

extension WeatherCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "miniForecastCell", for: indexPath) as? MiniForecastCollectionViewCell else {
            print("reusing cells failed")
            return UICollectionViewCell()
        }
        
        //cell.forecastImage.image
        cell.forecastTemp.text = "+25"
        cell.forecastTime.text = "12:00"
        return cell
    }
    
    
}
