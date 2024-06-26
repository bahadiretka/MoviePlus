//
//  SignInViewController.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 24.06.2024.
//

import UIKit
import FirebaseAuth

class SignInViewController: BaseViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        SignUpViewController.push(from: self)
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let email = email.text, !email.isEmpty,
              let password = password.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Email and password must not be empty.")
            return
        }
        
        FirebaseAuthManager.shared.login(withEmail: email, password: password) { result in
            switch result {
            case .success(let authResult):
                print("User signed in: \(authResult.user.email ?? "")")
                self.homeView()
            case .failure(let error):
                self.showAlert(title: "Sign In Error", message: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    static func push(from: UIViewController) {
        let board = UIStoryboard(name: "Login", bundle: nil)
        if let vc = board.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController {
            from.navigationController?.setNavigationBarHidden(true, animated: false)
            from.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
