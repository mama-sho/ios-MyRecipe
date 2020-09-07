//
//  NextTableViewCell.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/09/01.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit

class NextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var cocktailImageView: UIImageView!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailTextView.textColor = .white
        userNameLabel.textColor = .white
        detailTextView.backgroundColor = .clear
        self.backgroundColor = .clear
        userImageView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
