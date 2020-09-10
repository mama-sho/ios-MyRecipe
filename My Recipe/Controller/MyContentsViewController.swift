//
//  MyContentsViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/09/02.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit

class MyContentsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cocktailNameArray = UserDefaults.standard.array(forKey: "cocktailName") as? [String] ?? []
    var cocktailImageDataArray = UserDefaults.standard.array(forKey: "cocktailImage") as? [Data] ?? []
    var detailTextArray = UserDefaults.standard.array(forKey: "detailText") as? [String] ?? []
    var recipeArray = UserDefaults.standard.array(forKey: "recipe") as? [Array<String>] ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(cocktailNameArray)
        print(recipeArray)
        print(detailTextArray)
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        
        //セルのレイアウト
        let layout = UICollectionViewFlowLayout()
        //セルの大きさ
        layout.itemSize = CGSize(width: 105, height: 120)
        //セルとセルの間の大きさを決める
        layout.minimumInteritemSpacing = 4
        //行の間の長さ
        layout.minimumLineSpacing = 2
        collectionView.collectionViewLayout = layout
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cocktailNameArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        
        cell.backgroundColor = .clear
        cell.cocktailNameLabel.text = cocktailNameArray[indexPath.row]
        cell.cocktailNameLabel.textColor = .white
        cell.cocktailImage.image = UIImage(data: cocktailImageDataArray[indexPath.row])
        
        return cell
    }
    
    // セルがタップされたら詳細画面に値を渡して画面遷移
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("タップされました")
        
        let nextVC = self.storyboard?.instantiateViewController(identifier: "CocktailDetailViewController") as CocktailDetailViewController?
        
        nextVC!.cocktailName = cocktailNameArray[indexPath.row]
        nextVC!.cocktailImageData = cocktailImageDataArray[indexPath.row]
        nextVC!.detailText = detailTextArray[indexPath.row]
        nextVC!.recipe = recipeArray[indexPath.row]
        
        self.present(nextVC!, animated: true, completion: nil)
        
    }
    

    @IBAction func MenuButton(_ sender: Any) {

        let MenuViewController = self.storyboard?.instantiateViewController(identifier: "MenuViewController") as! MenuViewController
        
        self.present(MenuViewController, animated: true, completion: nil)
        
    }
}
