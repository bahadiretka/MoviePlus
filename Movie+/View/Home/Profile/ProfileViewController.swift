//
//  ProfileViewController.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 25.06.2024.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = FirebaseAuthManager.shared.getCurrentUser() else { return }
        emailLabel.text = user.email
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        FirebaseAuthManager.shared.logout { result in
            switch result {
            case .success:
                self.loginView()
            case .failure(let error):
                self.presentAlert(with: "Error", message: "An error occurred while logging out: \(error.localizedDescription)")
            }
        }
    }
    
    private func presentAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
