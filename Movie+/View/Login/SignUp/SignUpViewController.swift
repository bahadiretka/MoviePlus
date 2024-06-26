//
//  SignUpViewController.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 24.06.2024.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let email = email.text, !email.isEmpty,
              let password = password.text, !password.isEmpty,
              let confirmPassword = confirmPassword.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "All fields must be filled.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }
        
        FirebaseAuthManager.shared.createUser(withEmail: email, password: password) { result in
            switch result {
            case .success(let authResult):
                print("User signed up: \(authResult.user.email ?? "")")
                self.showAlert(title: "Success", message: "User signed up successfully.")
            case .failure(let error):
                self.showAlert(title: "Sign Up Error", message: error.localizedDescription)
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
        if let vc = board.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            from.navigationController?.setNavigationBarHidden(true, animated: false)
            from.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
