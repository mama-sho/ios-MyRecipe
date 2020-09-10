//
//  MyContents.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/09/02.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import Foundation

//data型にできるようにするためにCodableに準拠させる
class MyContents:Codable {
    
    var userName:String = ""
    
    var cocktailImage:Data
    
    var userImage:Data
    
    var cocktailName:String = ""
    
    var detail:String = ""
    
    var recipe = [String]()
    
    init(userName:String,cocktailImage:Data,userImage:Data,cocktailName:String,detail:String,recipe:Any) {
        
        self.userName = userName
        self.cocktailImage = cocktailImage
        self.cocktailName = cocktailName
        self.detail = detail
        self.recipe = recipe as! [String]
        self.userImage = userImage
        
    }
    
}
