//
//  DetailViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/31.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//


//scrollViewの設定,googlesartchで画像を取得
//cocktail_descがから

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage

class DetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var cocktail_name = ""
    var top_name = ""
    var style_name = ""
    var cocktail_digest = ""
    var base = ""
    var taste = ""
    var technique = ""
    var glass = ""
    var alcohol = 0
    var cocktail_desc = ""
    var recipe_desc = ""
    var recipe = [JSON]()
    
    @IBOutlet weak var cocktailNameLabel: UILabel!
    
    @IBOutlet weak var cocktail_digestLabel: UILabel!
    
    @IBOutlet weak var cocktailImage: UIImageView!
    
    @IBOutlet weak var techniqueLabel: UILabel!
    
    @IBOutlet weak var alcoholLabel: UILabel!
    
    @IBOutlet weak var baseLabel: UILabel!
    
    @IBOutlet weak var glassLabel: UILabel!
    
    @IBOutlet weak var cocktail_descTextView: UITextView!
    
    @IBOutlet weak var recipe_descTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tasteLabel: UILabel!
    
    var cocktailImageArray = [String]()
    
    var imageCount = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cocktailNameLabel.text = cocktail_name
        cocktail_digestLabel.text = cocktail_digest
        tasteLabel.text = taste
        techniqueLabel.text = technique
        alcoholLabel.text = String(alcohol) + "℃"
        baseLabel.text = base
        glassLabel.text = glass
        
        cocktail_descTextView.text = cocktail_desc
        recipe_descTextView.text = recipe_desc
        cocktail_descTextView.isEditable = false
        recipe_descTextView.isEditable = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
        
        imageGetMethod(searchName: cocktail_name)
        
    }
    
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.count
    }
    
    
    //セルを生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as! DetailTableViewCell
        
        // 選択された時の、ハイライトを消す
        cell.selectionStyle = .none
        
        let ingredient_name = recipe[indexPath.row]["ingredient_name"].string
        var amount = recipe[indexPath.row]["amount"].string
        
        
        if amount?.isEmpty == nil {
            amount = ""
        }
        
        let unit = recipe[indexPath.row]["unit"].string
        let amount_unit = amount! + unit!
        
        cell.ingredientNameLabel.text = ingredient_name
        cell.amount_unitLable.text = amount_unit
        
        return cell
    }
    
    
    @IBAction func menuButton(_ sender: Any) {
    
        let MenuViewController = self.storyboard?.instantiateViewController(identifier: "MenuViewController") as! MenuViewController
        
        MenuViewController.modalTransitionStyle = .coverVertical
        self.present(MenuViewController, animated: true, completion: nil)
        
    }
    
    //google custom SearchAPI
    
    
    func imageGetMethod(searchName:String) {
        
        let APIkey = "AIzaSyDvP-b6BveNKOsR04L1oSf1pZ52Kv02t6M"
        let enginID = "050dc933874ea747c"
        let searchURLString = "https://www.googleapis.com/customsearch/v1"
        
        let URL = "https://www.googleapis.com/customsearch/v1?key=AIzaSyDvP-b6BveNKOsR04L1oSf1pZ52Kv02t6M&cx=050dc933874ea747c&searchType=image&num=5&q=カクテル\(searchName)"
        
        //エンコードしないとダメだった...
        let encodedUrl = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
        AF.request(encodedUrl!, method: .get, parameters: nil, encoding:JSONEncoding.default).responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("success");
                let json:JSON = JSON(response.data as Any)
                let items = json["items"]
                
                for i in 0 ..< items.count {
                    let imageURL = items[i]["link"].string
                    self.cocktailImageArray.append(imageURL!)
                }
                
                let imageData = self.getImageByUrl(url: self.cocktailImageArray[0])
                self.cocktailImage.image = imageData
                
                break
            case .failure(let error):
                print("failue")
                print(error);
                break
                
            }
        }
    }
    
    //url をimage型に変換するメソッド
    func getImageByUrl(url: String) -> UIImage{ //urlがnil
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
    
    @IBAction func button(_ sender: Any) {
        if imageCount >= 4 {
            imageCount = 0
        } else {
            imageCount = imageCount + 1
        }
        let imageData = getImageByUrl(url: cocktailImageArray[imageCount])
        
        cocktailImage.image = imageData
    }
    
}
