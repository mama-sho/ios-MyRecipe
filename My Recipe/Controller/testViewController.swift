//
//  testViewController.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/09/01.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet weak var scroller: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroller.isScrollEnabled = true
        scroller.contentSize = CGSize(width: 414,height: 1000)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
