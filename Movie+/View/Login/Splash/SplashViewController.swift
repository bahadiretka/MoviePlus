//
//  SplashViewController.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 24.06.2024.
//

import UIKit
import FirebaseAuth
import UserNotifications

class SplashViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleLogin()
    }
    
    func handleLogin() {
        DispatchQueue.main.async {
            if let _ = FirebaseAuthManager.shared.getCurrentUser() {
                self.homeView()
            } else {
                self.loginView()
            }
        }
    }
}
