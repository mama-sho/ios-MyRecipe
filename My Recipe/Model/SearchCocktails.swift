//
//  SearchCocktails.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/29.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import Foundation

class searchCocktails {
    
    var cocktail_id = 0
    var cocktail_name = ""
    var base = ""
    var technique = ""
    var taste = ""
    var style = ""
    var alcohol = ""
    var top = ""
    var glass = ""
    var cocktail_digest = ""
    var cocktail_desc = ""
    

    init(cocktail_id:Int,  cocktail_name:String,base:String,technique:String,taste:String,style:String,alcohol:Int,top:String,glass:String,cocktail_digest:String,cocktail_desc:String) {
        
        self.cocktail_id = cocktail_id
        self.cocktail_name = cocktail_name
        self.base = base
        self.technique = technique
        self.taste = taste
        self.style = style
        self.alcohol = String(alcohol)
        self.top = top
        self.glass = glass
        self.cocktail_digest = cocktail_digest
        self.cocktail_desc = cocktail_desc
        
    }
}
