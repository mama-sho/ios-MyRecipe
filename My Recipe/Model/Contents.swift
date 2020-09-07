//
//  Cocktaile.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/14.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import Foundation

class Contents {
    
    var userName:String = ""
    
    var cocktailImage:String = ""
    
    var userImage:String = ""
    
    var cocktailName:String = ""
    
    var detail:String = ""
    
    var recipe = [String]()
    
    init(userName:String,cocktailImage:String,userImage:String,cocktailName:String,detail:String,recipe:Any) {
        
        self.userName = userName
        self.cocktailImage = cocktailImage
        self.cocktailName = cocktailName
        self.detail = detail
        self.recipe = recipe as! [String]
        self.userImage = userImage
        
    }
    
}
