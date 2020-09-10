//
//  CollectionViewCell.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/09/02.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cocktailNameLabel: UILabel!
    
    @IBOutlet weak var cocktailImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
