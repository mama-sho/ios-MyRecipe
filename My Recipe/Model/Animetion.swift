//
//  Animetion.swift
//  My Recipe
//
//  Created by 上田大樹 on 2020/09/07.
//  Copyright © 2020 ueda.daiki. All rights reserved.
//

import Foundation
import Lottie
import UIKit

class Animetion {
    
    func loadAnimetion () {
        let animationView = AnimationView(name: "Animation")
        animationView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1

        view.addSubview(animationView)

        animationView.play()
    }
}
