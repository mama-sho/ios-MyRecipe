//
//  SearchViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/18.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var SearchCocktails = [searchCocktails]()
    
    //searchMenu.Controolerから値を受け取るために変数を用意する
    var word:String?
    var base:String?
    var taste:String?
    var technique:String?
    var glass:String?
    var top:String?
    var style:String?
    var alcohol:String?

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    var APIURL = "https://cocktail-f.com/api/v1/cocktails"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectParameter(base: base, word: word, taste: taste, technique: technique, glass: glass, top: top, style: style, alcohol: alcohol)
        
        getData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        //！！！重要！！！ xibファイルを登録
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        
    }
    
    
    func getData() {
        //Alamofireでapiにリクエスト
        AF.request(APIURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch (response.result) {
            case .success:
                //JSON解析
                let json:JSON = JSON(response.data as Any)
                let cocktails = json["cocktails"]
                
                for i in 0 ..< cocktails.count {
                    
                    let cocktail_id = json["cocktails"][i]["cocktail_id"].int
                    let cocktail_name = json["cocktails"][i]["cocktail_name"].string
                    var base_name = json["cocktails"][i]["base_name"].string
                    let technique_name = json["cocktails"][i]["technique_name"].string
                    let taste_name = json["cocktails"][i]["taste_name"].string
                    let style_name = json["cocktails"][i]["style_name"].string
                    let alcohol = json["cocktails"][i]["alcohol"].int
                    let top_name = json["cocktails"][i]["top_name"].string
                    let glass_name = json["cocktails"][i]["glass_name"].string
                    let cocktail_digest = json["cocktails"][i]["cocktail_digest"].string
                    let cocktail_desc = json["cocktails"][i]["cocktail_desc"].string
                    
                    //base がnilの時がある
                    if base_name == nil {
                        base_name = ""
                    }
                    
                    self.SearchCocktails.append(searchCocktails(cocktail_id: cocktail_id!, cocktail_name: cocktail_name!, base: base_name!, technique: technique_name!, taste: taste_name!, style: style_name!, alcohol: alcohol!, top: top_name!, glass: glass_name!, cocktail_digest: cocktail_digest!, cocktail_desc: cocktail_desc!))
                }
                
                break
                
            case .failure:
                print("error");
                break
            }
            self.tableView.reloadData()
        }
    }
    
    //cellの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        countLabel.text = String(SearchCocktails.count) + "件"
        
        return SearchCocktails.count
     }
    
    //cellの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
     
    //cellを生成
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! TableViewCell
        
        //cocktail_idをcellのタグにつける
        cell.tag = SearchCocktails[indexPath.row].cocktail_id
        
        cell.cocktailNameLabel.text = SearchCocktails[indexPath.row].cocktail_name
        cell.baseLabel.text = SearchCocktails[indexPath.row].base
        cell.techniqueLabel.text = SearchCocktails[indexPath.row].technique
        cell.tasteLabel.text = SearchCocktails[indexPath.row].taste
        cell.alcoholLabel.text = SearchCocktails[indexPath.row].alcohol + "℃"
        cell.glassLabel.text = SearchCocktails[indexPath.row].glass
        
        return cell
     }
    
    //Cellが選択されたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("タップされました")
    
        let cocktail_id = SearchCocktails[indexPath.row].cocktail_id

        //Alamofireでカクテル詳細APIを叩く
        let APIURL2 = "https://cocktail-f.com/api/v1/cocktails/" + String(cocktail_id)
    
        AF.request(APIURL2, method: .get, parameters: nil,encoding: JSONEncoding.default).responseJSON { (response) in
            
            
            switch response.result {
                case .success:
                    //JSON解析
                    let json:JSON = JSON(response.data as Any)
                    
                    let cocktail_name = json["cocktail"]["cocktail_name"].string
                    let base_name = json["cocktail"]["base_name"].string
                    let technique_name = json["cocktail"]["technique_name"].string
                    let taste_name = json["cocktail"]["taste_name"].string
                    let style_name = json["cocktail"]["style_name"].string
                    let alcohol = json["cocktail"]["alcohol"].int
                    let top_name = json["cocktail"]["top_name"].string
                    let glass_name = json["cocktail"]["glass_name"].string
                    let cocktail_digest = json["cocktail"]["cocktail_digest"].string
                    let cocktail_desc = json["cocktail"]["cocktail_desc"].string
                    let recipe_desc = json["cocktail"]["recipe_desc"].string
                    let recipes = json["cocktail"]["recipes"].array
                    
                    let nextVC = self.storyboard?.instantiateViewController(identifier: "DetailViewController") as DetailViewController?
                    
                    //値を画面遷移先に渡す
                    nextVC!.cocktail_name = cocktail_name!
                    nextVC!.cocktail_digest = cocktail_digest! // nil
                    nextVC!.cocktail_desc = cocktail_desc!
                    nextVC!.base = base_name!
                    nextVC!.taste = taste_name! // nil
                    nextVC!.alcohol = alcohol!
                    nextVC!.glass = glass_name!
                    nextVC!.recipe_desc = recipe_desc!
                    nextVC!.technique = technique_name!
                    nextVC!.style_name = style_name!
                    nextVC!.top_name = top_name!
                    nextVC!.recipe = recipes!
                    
                    //画面遷移
                    self.present(nextVC!, animated: true, completion: nil)
                    
                    
                    break;
                
                case .failure:
                    print("error");
                    break
                
                default:
                    print("失敗");
                    break
            }
           
        }
    }
    
    @IBAction func searchButton(_ sender: Any) {
        //画面遷移 上部スクロールで、検索欄を表示する
        print("search")
    }
    
    //メニューを表示
    @IBAction func menuButton(_ sender: Any) {
        
        let MenuViewController = self.storyboard?.instantiateViewController(identifier: "MenuViewController") as! MenuViewController
        
        MenuViewController.modalTransitionStyle = .coverVertical
        self.present(MenuViewController, animated: true, completion: nil)
        
    }
    
    
    func selectParameter(base:String?,word:String?,taste:String?,technique:String?,glass:String?,top:String?,style:String?,alcohol:String?) {
        
        
            var parameterString = ""
            
            if base != nil || word != nil || taste != nil || technique != nil || glass != nil || top != nil || style != nil || alcohol != nil {
                
                if base != "" {
                    
                    var baseString = ""
                    
                    switch base {
                    case "ジン":
                        baseString = "1";
                        break
                    case "ウォッカ":
                        baseString = "2";
                        break
                    case "テキーラ":
                        baseString = "3";
                        break
                    case "ラム":
                        baseString = "4";
                        break
                    case "ウィスキー":
                        baseString = "5";
                        break
                    case "ブランデー":
                        baseString = "6";
                        break
                    case "リキュール":
                        baseString = "7";
                        break
                    case "ワイン":
                        baseString = "8";
                        break
                    case "ビール":
                        baseString = "9";
                        break
                    case "日本酒":
                        baseString = "10";
                        break
                    case "ノンアルコール":
                        baseString = "0";
                        break
                    default:
                        print("baseError");
                        break
                    }
                    parameterString = parameterString + "&base=" + baseString
                }
                
                if word != "" {
                    
                    parameterString = parameterString + "&word=" + word!
                }
                
                if taste != "" {
                    
                    var tasteString = ""
                    
                    switch taste {
                    case "甘口":
                        tasteString = "1";
                        break
                    case "中甘口":
                        tasteString = "2";
                        break
                    case "中口":
                        tasteString = "3";
                        break
                    case "中辛口":
                        tasteString = "4";
                        break
                    case "辛口":
                        tasteString = "5";
                        break
                    default:
                        print("tasteError")
                        break
                    }
                    parameterString = parameterString + "&taste=" + tasteString
                    
                }
                
                if technique != "" {

                    var techniqueString = ""
                    
                    switch technique {
                    case "ビルド":
                        techniqueString = "1";
                        break
                    case "ステア":
                        techniqueString = "2";
                        break
                    case "シェイク":
                        techniqueString = "3";
                        break
                    default:
                        print("techniqueError");
                        break
                    }
                    parameterString = parameterString + "&technique=" + techniqueString
                }
                
                if glass != "" {

                    var glassString = ""
                    
                    switch glass {
                    case "カクテルグラス":
                        glassString = "1";
                        break
                    case "オールドファッションドグラス":
                        glassString = "2";
                        break
                    case "コリンズグラス":
                        glassString = "3";
                        break
                    case "タンブラー":
                        glassString = "4";
                        break
                    case "ワイングラス":
                        glassString = "5";
                        break
                    case "シャンパングラス":
                        glassString = "6";
                        break
                    case "ホットグラス":
                        glassString = "7";
                        break
                    case "ゴブレット":
                        glassString = "8";
                        break
                    case "リキュールグラス":
                        glassString = "9";
                        break
                    case "サワーグラス":
                        glassString = "10";
                        break
                    case "ピルスナーグラス":
                        glassString = "11";
                        break
                    default:
                        print("glassError")
                    }
                    parameterString = parameterString + "&glass=" + glassString
                }
                
                if top != "" {
                    
                    var topString = ""
                    
                    switch top {
                    case "食前":
                        topString = "1";
                        break
                    case "食後":
                        topString = "2";
                        break
                    case "オール":
                        topString = "3";
                        break
                    default:
                        print("topError");
                        break
                    }
                    parameterString = parameterString + "&top=" + topString
                }
                
                if style != "" {
                    
                    var styleString = ""
                    
                    switch style {
                    case "ショート":
                        styleString = "1";
                        break
                    case "ロング":
                        styleString = "2";
                        break
                    default:
                        print("styleError");
                        break
                    }
                    
                    parameterString = parameterString + "&style=" + styleString
                }
                
                if alcohol != "" {

                    var alcohol_from = ""
                    var alcohol_to = ""
                    
                    switch alcohol {
                    case "0 ~ 15":
                        alcohol_from = "0"
                        alcohol_to = "15";
                        break
                    case "16 ~ 25":
                        alcohol_from = "16"
                        alcohol_to = "25";
                        break
                    case "26 ~ 40":
                        alcohol_from = "26"
                        alcohol_to = "40";
                        break
                    case "41 ~":
                        alcohol_from = "41"
                        alcohol_to = "99";
                        break
                    default:
                        print("alcoholError")
                        break
                    }
                    
                    parameterString = parameterString + "&alcohol_from=" + alcohol_from + "&alcohol_to=" + alcohol_to
                }
            
                let dropParameter = parameterString.dropFirst(1)
                //パラメータ-を追加
                APIURL = APIURL + "?" + dropParameter
                print(APIURL)
            }
            
    }
    
}
