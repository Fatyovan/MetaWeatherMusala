//
//  CityTableViewCell.swift
//  MetaWeatherMusala
//
//  Created by Ivan Jovanovik on 3/4/20.
//  Copyright © 2020 Ivan Jovanovik. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cityNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
