//
//  LoginNavigationController.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//

import UIKit

class LoginNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func push(from: UIViewController) {
        let board = UIStoryboard(name: "Login", bundle: nil)
        if let vc = board.instantiateViewController(withIdentifier: "LoginNavigationController") as? LoginNavigationController {
            from.navigationController?.setNavigationBarHidden(true, animated: false)
            from.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
