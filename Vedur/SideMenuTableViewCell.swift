//
//  SideMenuTableViewCell.swift
//  Vedur
//
//  Created by Alex Kagarov on 6/23/19.
//  Copyright © 2019 Alex Kagarov. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {
    
    //  OUTLETS
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var settingsNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
