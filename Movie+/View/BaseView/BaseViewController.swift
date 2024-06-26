//
//  BaseViewController.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 24.06.2024.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func homeView(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(viewController)
    }
    
    func loginView() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as? LoginNavigationController else { return }
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(viewController)
    }
    
    func setupController() {
        
    }
    
    func setupUI() {
        
    }

}
