//
//  ViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/07.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

/*
 
 機能

 //ノルマーーーー
  googleAPIで画像を取得
  scrollViewの実装
  TableViewで、投稿カクテル一覧表示
  collectionで、自分が保存しているカクテル一覧を表示
  上部二つの詳細画面
 
 
 
 ・SNS共有アクションシート
 ・SwiftBoardIDで画面遷移する時にkindをPresentModallyにしたい
 ・画像の色を黄色に変更したい
 ・ロード中はlottileでアニメーションを流す
 ・ツイッターログイン

 */

import UIKit
import Firebase
import Photos

class ViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var alertController = UIAlertController()
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var cocktailImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var PhotoLabel: UILabel!
    
    @IBOutlet weak var sininButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userNameTextField.text = (UserDefaults.standard.object(forKey: "userName") as! String)
            let image = (UserDefaults.standard.object(forKey: "userImage") as! Data)
            userImageView.image = UIImage(data: image)
            
            sininButton.setTitle("ログイン", for: .normal)
            sininButton.backgroundColor = .brown
            
        }
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch (status) {
            case .authorized:
                print("認証されましたカメラ");
            case .denied:
                print("拒否されました");
            case .notDetermined:
                print("notDetermined");
            case .restricted:
                print("restricted");
            }
        }
                
        userImageView.layer.cornerRadius = 60
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        userImageView.isUserInteractionEnabled = true
    
        //imgaeviewタップアクション
        userImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ActionSheet)))
        
        //キーボードが閉じる時
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
         //キーボードが閉じる時
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //キーボードを閉じる処理 Retuern と　キーボード以外のタップ
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //キーボードの大きさに合わせてViewを上下させる
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
    
    
    //新規作成ユーザー
    @IBAction func sinIn(_ sender: Any) {
        
        if sininButton.titleLabel?.text == "ログイン" {
            //ログイン処理
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error != nil {
                    print(error as Any)
                } else {
                    print("ログイン成功")
                    //画面遷移　segueID
                    self.performSegue(withIdentifier: "next", sender: nil)
                    
                }
                
            }
        } else {
            
            //新規作成
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) {
                (user, error) in
                
                print(self.userImageView.image as Any)
                
                    
                if error != nil  || self.userNameTextField.text == nil{
                        self.alert(title: "登録できませんでした！", message: "正しいEmail形式ですか？　パスワードは何文字以内？")
                    } else {
                      print("成功")
                        //アプリ内にユーザーネームと画像を保存
                        UserDefaults.standard.set(self.userNameTextField.text, forKey: "userName")
                        //アイコンを保存 圧縮する
                        let data = self.userImageView.image?.jpegData(compressionQuality: 0.1)
                        UserDefaults.standard.set(data, forKey: "userImage")
                    
                        //画面遷移　segueID
                        self.performSegue(withIdentifier: "next", sender: nil)
                        
                    }
            }

            
        }
        
    }
    
    //アラート表示
    func alert(title:String,message:String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController,animated: true)
    }
    
    //アクションシート起動
    @objc func ActionSheet(_ sender: Any) {
        
        print("test-----------------")
        
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
        
        //ラベルを非表示にする
        PhotoLabel.isHidden = true
        
        if let pickedImage = info[.editedImage] as? UIImage {
            
            userImageView.image = pickedImage
            
            //写真の保存
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, nil, nil)
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    //キャンセルされた時の処理  カメラを閉じる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

