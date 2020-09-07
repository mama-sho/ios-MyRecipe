//
//  NewViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/16.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//


import UIKit
import Photos
import Firebase

class NewViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cocktailImageView: UIImageView!
    
    @IBOutlet weak var cocktailNameTextFiled: UITextField!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var detailsTextView: UITextView!
    
    @IBOutlet weak var recipeTextField: UITextField!
    
    @IBOutlet weak var selectLabel: UILabel!
    
    var alertController = UIAlertController()
    
    var recipe = [String]()
    
    let underline: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeTextField.delegate =  self
        cocktailNameTextFiled.delegate = self
        
        detailsTextView.layer.cornerRadius = 10
        cocktailNameTextFiled.attributedPlaceholder = NSAttributedString(string: "カクテル名", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        
        //ユーザーアイコンの表示
        if UserDefaults.standard.object(forKey: "userImage") != nil {
          let imageData = UserDefaults.standard.object(forKey: "userImage") as! Data
          let userImage = UIImage(data: imageData)!
          
          userImageView.image = userImage
            userImageView.layer.cornerRadius = 33
        }
        
        //imgaeviewタップアクション
        cocktailImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ActionSheet)))
        
        //tableView設定
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        //Cellの高さを決める
        tableView.estimatedRowHeight = 44
        
        //キーボードが開く時
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //キーボードが閉じる時
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //アクションシート起動
    @objc func ActionSheet(_ sender: Any) {
        
        let actionAlert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        //アルバムアクション追加
        let albamAction = UIAlertAction(title: "アルバムから選択", style: UIAlertAction.Style.default, handler: {
            (action:UIAlertAction!) in
            //アルバム起動
            self.openAlbam()
        })
        actionAlert.addAction(albamAction)
        
        //カメラアクション追加
        let cameraAction = UIAlertAction(title: "カメラ", style: UIAlertAction.Style.default) { (action: UIAlertAction!) in
            //カメラ起動
            self.openCamera()
        }
        actionAlert.addAction(cameraAction)
        
        //キャンセルアクションの追加
        let cancelAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel) { (action: UIAlertAction!) in
            print("キャンセル")
        }
        actionAlert.addAction(cancelAction)
        
        //アクションを表示
        self.present(actionAlert,animated: true, completion: nil)
        
    }
    
    //カメラ起動
    func openCamera() {
        
        let sourceType = UIImagePickerController.SourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.allowsEditing = true
            cameraPicker.delegate = self
            present(cameraPicker, animated: true,completion: nil)
        } else {
            print("エラー")
        }
    }
    
    //アルバム起動
    func openAlbam() {
        
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.allowsEditing = true
            cameraPicker.delegate = self
            present(cameraPicker, animated: true,completion: nil)
        } else {
            print("エラー")
        }
        
    }
    
    //撮影が終わった時、画像が選択された時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage {
            
            selectLabel.isHidden = true
            cocktailImageView.image = pickedImage
            
            //写真の保存
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, nil, nil)
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //キャンセルされた時の処理  カメラを閉じる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //メニュー遷移
    @IBAction func MenuButton(_ sender: Any) {
        let MenuViewController = self.storyboard?.instantiateViewController(identifier: "MenuViewController") as! MenuViewController
        
        MenuViewController.modalTransitionStyle = .coverVertical
        self.present(MenuViewController, animated: true, completion: nil)
    }
    
    //キーボードを閉じる処理 Retuern と　キーボード以外のタップ
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
     }
    
     @objc func keyboardWillHide() {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
        }
     }
    
    //TableView ---------------------------------------------------------------------------------
    //cellの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipe.count
    }
    
    //セルが選択された時にハイライトさせるかどうか
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    //セルを生成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //作成したカスタムセルを宣言
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! CustomCell
        
        cell.backgroundColor = .clear
        
        cell.recipeLabel.text = recipe[indexPath.row]
        
        return cell
    }
    
    //セルの高さを返すdelegateメソッド
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    
    //データベース　ストレージに追加
    @IBAction func postActionButton(_ sender: Any) {
        
        if cocktailNameTextFiled.text == nil || detailsTextView.text == nil || recipe.count <= 0 || cocktailImageView.image == nil {
            alert(title: "未入力の項目があります！", message: "画像(必須),カクテル名, レシピ, メモ欄")
            return
        }
        
        //UserDefarutoにも追加する
        //アイコン 圧縮する & 保存
        let cocktailImageData = cocktailImageView.image?.jpegData(compressionQuality: 0.1)
        let cocktailname = cocktailNameTextFiled.text
        let detailText = detailsTextView.text
        let cocktailName = cocktailNameTextFiled.text
        
        //一つ以上あるなら保存ではなく追加する
        if (UserDefaults.standard.array(forKey: "cocktailName") != nil) {
            
            var detail = UserDefaults.standard.array(forKey: "detailText") as? [String] ?? []
            detail.append(detailText!)
            UserDefaults.standard.set(detail, forKey: "detailText")
            
            var cocktail_name = UserDefaults.standard.array(forKey: "cocktailName") as? [String] ?? []
            cocktail_name.append(cocktailName!)
            UserDefaults.standard.set(cocktail_name, forKey: "cocktailName")
            
            var recipeArray = UserDefaults.standard.array(forKey: "recipe") as? [Array<String>] ?? []
            recipeArray.append(recipe)
            UserDefaults.standard.set(recipeArray, forKey: "recipe")
            
            var cocktail_image = UserDefaults.standard.array(forKey: "cocktailImage") as? [Data] ?? []
            cocktail_image.append(cocktailImageData!)
            UserDefaults.standard.set(cocktailImageData, forKey: "cocktailImage")
        } else {
            
            //初めての保存なら
            //配列にする
            let detailArray = [detailText]
            let cocktailNameArray = [cocktailname]
            let recipeArray = [recipe]
            let cocktailImageDataArray = [cocktailImageData]
                        
            //保存する配列で保存する
            UserDefaults.standard.set(cocktailNameArray,forKey: "cocktailName")
            UserDefaults.standard.set(detailArray, forKey: "detailText")
            UserDefaults.standard.set(recipeArray, forKey: "recipe")
            UserDefaults.standard.set(cocktailImageDataArray, forKey: "cocktailImage")
            
        }
        
        let database = Database.database().reference().child("cocktails")
        
        let storage = Storage.storage().reference(forURL: "gs://my-cocktail-fb47b.appspot.com")
        
        //ストレージの中にフォルダを入れる
        let key = database.child("Users").childByAutoId().key
        let key2 = database.child("contents").childByAutoId().key
        
        let imageRef = storage.child("Users").child("\(String(describing: key!)).jpg")
        let imageRef2 = storage.child("Contents").child("\(String(describing: key2!)).jpg")
        
        //画像をデータ型にする重いから
        var userProfileImageData:Data = Data()
        var contentImageData:Data = Data()
        if userImageView.image != nil {
            userProfileImageData = (userImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        if cocktailImageView.image != nil {
            contentImageData = (cocktailImageView.image?.jpegData(compressionQuality: 0.01))!
        }
                
        //putData 実際に保存する
        let uploadTask = imageRef.putData(userProfileImageData, metadata: nil) {
            (metadata, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            let uploadTask2 = imageRef2.putData(contentImageData, metadata: nil) {
                (metadata, error) in
                
                if error != nil {
                    print(error as Any)
                }
                
                //ストレージ画像を保存しているURLを取得してデータベースに保存
                imageRef.downloadURL { (url, error) in
                    if url != nil {
                        imageRef2.downloadURL { (url2, error) in
                            if url2 != nil {
                                //Key:Value型で保存
                                let userName = UserDefaults.standard.object(forKey: "userName")
                                let databaseInfo = ["userName": userName as Any,"userImage":url?.absoluteString as Any,"cocktailImage": url2?.absoluteString as Any,"cocktailName":self.cocktailNameTextFiled.text as Any, "detailsText": self.detailsTextView.text as Any,"resipi": self.recipe]
                                
                                //databaseに追加する
                                database.childByAutoId().setValue(databaseInfo)

                                //画面遷移
                                let NextViewController = self.storyboard?.instantiateViewController(identifier: "NextViewController") as NextViewController?
                                    
                                self.present(NextViewController!, animated: true, completion: nil)
                                
                            }
                        }
                    }
                }
            }
        }
        
        uploadTask.resume()
        self.dismiss(animated: true, completion: nil)
        
    }
    //レシピの追加
    @IBAction func recipeAddButton(_ sender: Any) {
        
        if recipeTextField.text!.count > 0 {
            print(recipeTextField.text!.count)
             recipe.append(recipeTextField.text!)
            recipeTextField.text = ""
         }
        //リロード
        tableView.reloadData()
    }
    
    //レシピを削除
    @IBAction func clearButton(_ sender: Any) {
        recipe.removeAll()
        print(recipe)
        tableView.reloadData()
    }
    
    //アラート表示
    func alert(title:String,message:String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController,animated: true)
    }
}
