//
//  FirebaseAuthManager.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 24.06.2024.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import UserNotifications

class FirebaseAuthManager {
    
    static let shared = FirebaseAuthManager()
    
    private init() {}
    
    func login(withEmail email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                AnalyticsManager.shared.logEvent(.userLogin)
                self.sendNotification(title: "Login Success", body: "You have successfully logged in.") { result in
                    switch result {
                    case .success:
                        print("Notification sent successfully.")
                    case .failure(let error):
                        print("Failed to send notification: \(error)")
                    }
                }
                completion(.success(authResult))
            }
        }
    }
    
    func createUser(withEmail email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let authResult = authResult {
                AnalyticsManager.shared.logEvent(.userSignUp)
                self.sendNotification(title: "Account Created", body: "Your account has been created successfully.") { result in
                    switch result {
                    case .success:
                        print("Notification sent successfully.")
                    case .failure(let error):
                        print("Failed to send notification: \(error)")
                    }
                }
                completion(.success(authResult))
            }
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func handleGoogleSignIn(presentingViewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = signResult?.user,
                  let idToken = user.idToken else {
                completion(.failure(NSError(domain: "com.bahadir", code: -1, userInfo: [NSLocalizedDescriptionKey: "Authentication failed."])))
                return
            }
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let user = authResult?.user {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "com.bahadir", code: -1, userInfo: [NSLocalizedDescriptionKey: "Authentication failed."])))
                }
            }
        }
    }
    
    private func sendNotification(title: String, body: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}
