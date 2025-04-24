//
//  SplashViewController.swift
//  not-App
//
//  Created by furkan yetgin on 24.04.2025.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2 saniye bekle sonra login ekranına segue ile git
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.performSegue(withIdentifier: "SplashToLogin", sender: self)
        }

    }
    
}
