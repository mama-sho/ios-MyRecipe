//
//  NextViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/16.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

/*
 collectionViewでデータベースにアクセスして表示
 
 
 */

import UIKit
import Firebase
import SDWebImage
import Lottie

class NextViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var contentsArray = [Contents]()
    
    lazy var loadingView: AnimationView = {
        let animationView = AnimationView(name: "lottie")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        animationView.center = self.view.center
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1

        return animationView
    }()
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fecthPostsData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NextTableViewCell", bundle: nil), forCellReuseIdentifier: "nextTableViewCell")
        tableView.backgroundColor = .clear
        
        // 処理を現時点から0.5秒後に実行する
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.tableView.reloadData()
        }
        
        //自分が保存したものがあれば
        if UserDefaults.standard.object(forKey: "MyContents") != nil {
            myLabel.text = "マイカクテルへ"
        }
        

    }
    
    
    //データベースにアクセス
    func fecthPostsData() {
        
        startLoading()
        
        let fetchDataRef = Database.database().reference().child("cocktails")
        
        fetchDataRef.observe(.childAdded) { (snapShot) in
            
            let snapShotData = snapShot.value as AnyObject
            
            let cocktail_name = snapShotData.value(forKey: "cocktailName")
            let cocktail_imageURL = snapShotData.value(forKey: "cocktailImage")
            let detailText = snapShotData.value(forKey: "detailsText")
            let userImageURL = snapShotData.value(forKey: "userImage")
            let userName = snapShotData.value(forKey: "userName")
            let recipeArray = snapShotData.value(forKey: "resipi")
            
            print("append---------in")
            print(userImageURL as Any)
            print("append-------out")
            
            self.contentsArray.append(Contents(userName: userName as! String, cocktailImage: cocktail_imageURL as! String, userImage: userImageURL as! String, cocktailName: cocktail_name as! String, detail: detailText as! String, recipe: recipeArray as Any))
            
            self.stopAnimetion()
        }
    }
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOFRowInSection----------------")
        print(contentsArray.count)
        
        return contentsArray.count
    }
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 341
    }
    
    //セルの生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellを生成")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "nextTableViewCell") as! NextTableViewCell
        
        cell.userNameLabel.text = contentsArray[indexPath.row].userName
        cell.detailTextView.text = contentsArray[indexPath.row].detail
        
        let cocktailImage = contentsArray[indexPath.row].cocktailImage
        let userImage = contentsArray[indexPath.row].userImage //nil
        
        //UIImage型に変換する
        let changeUserImage = getImageByUrl(url: userImage)
        let changeCocktailImage = getImageByUrl(url: cocktailImage)
        
        cell.userImageView.image = changeUserImage
        cell.cocktailImageView.image = changeCocktailImage
        
        
        return cell
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
    
    //セルがタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //値を渡して画面遷移
        let detailViewController = self.storyboard?.instantiateViewController(identifier: "CocktailDetailViewController") as CocktailDetailViewController?
        
        detailViewController!.cocktailName = contentsArray[indexPath.row].cocktailName
        detailViewController!.cocktailImageURL = contentsArray[indexPath.row].cocktailImage
        detailViewController!.userImageURL = contentsArray[indexPath.row].userImage
        detailViewController!.detailText = contentsArray[indexPath.row].detail
        detailViewController!.userName = contentsArray[indexPath.row].userName
        detailViewController!.recipe = contentsArray[indexPath.row].recipe
        
        self.present(detailViewController!,animated: true,completion: nil)
        
    }
    
    func startLoading() {
        view.addSubview(loadingView)
        loadingView.play()
    }
    func stopAnimetion () {
        loadingView.removeFromSuperview()
    }
}
