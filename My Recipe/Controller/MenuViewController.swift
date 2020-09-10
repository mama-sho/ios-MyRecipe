//
//  MenuViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/08/15.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //パーツの反映
        userImageView.layer.cornerRadius = 25
        
        userNameLabel.text = (UserDefaults.standard.object(forKey: "userName") as! String)
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            let imageData = UserDefaults.standard.object(forKey: "userImage") as! Data
            let userImage = UIImage(data: imageData)!
            
            userImageView.image = userImage
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // メニューの位置を取得する
        let menuPos = self.menuView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.menuView.layer.position.x = -self.menuView.frame.width
        // 表示時のアニメーションを作成する
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = menuPos.x
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
                        self.menuView.layer.position.x = -self.menuView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
    }
    
    
    @IBAction func myRecipeButton(_ sender: Any) {
        
        let NextViewController = self.storyboard?.instantiateViewController(identifier: "NextViewController") as NextViewController?
        
        self.present(NextViewController!, animated: true, completion: nil)
    }
    
    @IBAction func MyButton(_ sender: Any) {
        
        let VC = self.storyboard?.instantiateViewController(identifier: "MycocktailViewController") as MyContentsViewController?
        
        self.present(VC!,animated: true,completion: nil)
    }
}
