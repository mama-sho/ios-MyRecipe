//
//  File.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/09/01.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import Foundation

class Posts {
    
    var cocktailImageURL = ""
    var cocktailName = ""
    var userImageURL = ""
    var detailText = ""
    var userName = ""
    
    var recipe = [String]()
    
    init(cocktailURL:String,cocktailName:String,detailText:String,userName:String,userImageURL:String) {
        
        cocktailImageURL = cocktailURL
        self.cocktailName = cocktailName
        self.userImageURL = userImageURL
        self.detailText = detailText
        self.userName = userName
    }
}
