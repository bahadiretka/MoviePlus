//
//  LoginViewController.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 24.06.2024.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        SignInViewController.push(from: self)
    }
    
    @IBAction func googleSignInTapped(_ sender: Any) {
        FirebaseAuthManager.shared.handleGoogleSignIn(presentingViewController: self) { result in
            switch result {
            case .success(let user):
                print("User signed in with Google: \(user.email ?? "")")
                self.showAlert(title: "Success", message: "User signed in successfully.")
            case .failure(let error):
                self.showAlert(title: "Google Sign In Error", message: error.localizedDescription)
            }
        }
        
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
