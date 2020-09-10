//
//  CocktailDetailViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/09/03.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit
import SDWebImage

class CocktailDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var cocktailName = String()
    var cocktailImageData = Data()
    var recipe = [String]()
    var detailText = String()
    var userName = ""
    
    var cocktailImageURL = String()
    var userImageURL = String()
   
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var cocktailImage: UIImageView!
    
    @IBOutlet weak var detailTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cocktailNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 画面の反映
        //自分のカクテルなら
        if userName == "" {
            
            titleLabel.text = (UserDefaults.standard.object(forKey: "userName") as! String)
            
            let userImageData = UserDefaults.standard.object(forKey: "userImage") as! Data
            userImageView.image = UIImage(data: userImageData)
            cocktailImage.image = UIImage(data: cocktailImageData)
            
        } else {
            //自分のカクテルでないなら
            titleLabel.text = userName
            let userImgaeData = getImageByUrl(url: userImageURL)
            let cocktailImageData = getImageByUrl(url: cocktailImageURL)
            userImageView.image = userImgaeData
            cocktailImage.image = cocktailImageData
        }
        cocktailNameLabel.text = cocktailName
        detailTextView.text = detailText
        detailTextView.layer.cornerRadius = 3
        userImageView.layer.cornerRadius = 25
        tableView.backgroundColor = .clear
        
        //xibファイルの読み込み
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        print(recipe)
        
    }
    
    //tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellの生成")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        
        cell.backgroundColor = .clear
        cell.recipeLabel.text = recipe[indexPath.row]
        
        return cell
    }
    
    @IBAction func MenuButton(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(identifier: "MenuViewController") as MenuViewController?
        
        self.present(nextVC!,animated: true,completion: nil)
    }
    
    //url をimage型に変換するメソッド
    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}
