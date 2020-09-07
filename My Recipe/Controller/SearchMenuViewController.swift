//
//  SearchMenuViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/29.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit

class SearchMenuViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var searchMenuView: UIView!
    
    @IBOutlet weak var baseTextField: UITextField!
    
    @IBOutlet weak var wordTextField: UITextField!
    
    @IBOutlet weak var tasteTextField: UITextField!
    
    @IBOutlet weak var techniqueTextField: UITextField!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var glassTextField: UITextField!
    
    @IBOutlet weak var alcoholTextField: UITextField!
    
    @IBOutlet weak var styleTextField: UITextField!
    //pickerViewで表示する配列を用意する
    
    var baseArray = ["","ジン","ウォッカ","テキーラ","ラム","ウィスキー","ブランデー","リキュール","ワイン","ビール","日本酒","ノンアルコール"]
    var tasteArray = ["","甘口","中甘口","中口","中辛口","辛口"]
    
    var techniqueArray = ["","ビルド","ステア","シェイク"]
    
    var styleArray = ["","ショート","ロング"]
    
    var topArray = ["","食前","食後","オール"]
    
    var glassArray = ["","カクテルグラス","オールドファッションドグラス","コリンググラス","タンブラー","ワイングラス","シャンパングラス","ホットグラス","ゴブレット","リキュールグラス","サワーグラス","ピルスナーグラス"]
    
    var alcoholArray = ["0 ~ 15","16 ~ 25","26 ~ 40","41 ~"]
    
    //各pickerViewのインスタンスを作成
    let basePickerView:UIPickerView = UIPickerView()
    let tastePickerView:UIPickerView = UIPickerView()
    let techniquePickerView:UIPickerView = UIPickerView()
    let stylePickerView:UIPickerView = UIPickerView()
    let topPickerView:UIPickerView = UIPickerView()
    let glassPickerView:UIPickerView = UIPickerView()
    let alcoholPickerView:UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makePickerKeyBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           // メニューの位置を取得する
           let menuPos = self.searchMenuView.layer.position
           // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
           self.searchMenuView.layer.position.x = -self.searchMenuView.frame.width
           // 表示時のアニメーションを作成する
           UIView.animate(
               withDuration: 0.5,
               delay: 0,
               options: .curveEaseOut,
               animations: {
                   self.searchMenuView.layer.position.x = menuPos.x
           },
               completion: { bool in
           })
           
       }
    
    // メニューエリア以外タップ時の処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.searchMenuView.layer.position.x = -self.searchMenuView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
    }
    
    //pickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    //pickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView.tag {
        case 1:
            return baseArray[row];
        case 2:
            return tasteArray[row];
        case 3:
            return techniqueArray[row];
        case 4:
            return styleArray[row];
        case 5:
            return topArray[row];
        case 6:
            return glassArray[row];
        case 7:
            return alcoholArray[row];
        default:
            return "error";
        }
    }
    
    //picxkerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return baseArray.count;
        case 2:
            return tasteArray.count;
        case 3:
            return techniqueArray.count;
        case 4:
            return styleArray.count;
        case 5:
            return topArray.count;
        case 6:
            return glassArray.count;
        case 7:
            return alcoholArray.count;
        default:
            return 0
        }
    }
    
    //pickerが選択された際に呼ばれる処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
            case 1:
                return baseTextField.text = baseArray[row];
            case 2:
                return tasteTextField.text = tasteArray[row];
            case 3:
                return techniqueTextField.text = techniqueArray[row];
            case 4:
                return styleTextField.text = styleArray[row];
            case 5:
                return topTextField.text = topArray[row];
            case 6:
                return glassTextField.text = glassArray[row];
            case 7:
                return alcoholTextField.text = alcoholArray[row];
            default:
            return
        }
    }
    
    //キーボードをpickerViewを設定する
    func makePickerKeyBoard(){
        
        basePickerView.tag = 1
        basePickerView.delegate = self
        baseTextField.inputView = basePickerView
        baseTextField.delegate = self
        
        tastePickerView.tag = 2
        tastePickerView.delegate = self
        tasteTextField.inputView = tastePickerView
        tasteTextField.delegate = self
        
        techniquePickerView.tag = 3
        techniquePickerView.delegate = self
        techniqueTextField.inputView = techniquePickerView
        techniqueTextField.delegate = self
        
        stylePickerView.tag = 4
        stylePickerView.delegate = self
        styleTextField.inputView = stylePickerView
        styleTextField.delegate = self
        
        topPickerView.tag = 5
        topPickerView.delegate = self
        topTextField.inputView = topPickerView
        topTextField.delegate = self
        
        glassPickerView.tag = 6
        glassPickerView.delegate = self
        glassTextField.inputView = glassPickerView
        glassTextField.delegate = self
        
        alcoholPickerView.tag = 7
        alcoholPickerView.delegate = self
        alcoholTextField.inputView = alcoholPickerView
        alcoholTextField.delegate = self
    }


    @IBAction func SearchButton(_ sender: Any) {
        
        let nextVC = self.storyboard?.instantiateViewController(identifier: "SearchViewController") as SearchViewController?
        
        //値を画面遷移先に渡す
        nextVC!.base = baseTextField.text!
        nextVC!.word = wordTextField.text!
        nextVC!.taste = tasteTextField.text!
        nextVC!.technique = techniqueTextField.text!
        nextVC!.top = topTextField.text!
        nextVC!.glass = glassTextField.text!
        nextVC!.style = styleTextField.text!
        nextVC!.alcohol = alcoholTextField.text!
        
        //画面遷移
        self.present(nextVC!, animated: true, completion: nil)
    }
    
}
