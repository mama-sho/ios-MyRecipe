//
//  DetailTableViewCell.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/31.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientNameLabel: UILabel!
    
    @IBOutlet weak var amount_unitLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
  
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
