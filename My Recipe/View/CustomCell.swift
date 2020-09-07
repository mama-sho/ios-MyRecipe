//
//  CustomCell.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/16.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet weak var recipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        recipeLabel.backgroundColor = .clear
        recipeLabel.textColor = .systemYellow
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
