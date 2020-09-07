//
//  TableViewCell.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/29.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cocktailNameLabel: UILabel!
    
    @IBOutlet weak var baseLabel: UILabel!
    
    @IBOutlet weak var glassLabel: UILabel!
        
    @IBOutlet weak var alcoholLabel: UILabel!
    
    @IBOutlet weak var tasteLabel: UILabel!
    
    @IBOutlet weak var techniqueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
