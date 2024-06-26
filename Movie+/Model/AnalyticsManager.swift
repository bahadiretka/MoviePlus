//
//  FirebaseAnalyticsManager.swift
//  Movie+
//
//  Created by Bahadır Etka Kılınç on 26.06.2024.
//

import Foundation
import FirebaseAnalytics

class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func logEvent(_ event: AnalyticsEvent, parameters: [String: Any]? = nil) {
        Analytics.logEvent(event.rawValue, parameters: parameters)
        print("Event logged: \(event.rawValue) with parameters: \(String(describing: parameters))")
    }
    
    enum AnalyticsEvent: String {
        case userSignUp = "user_sign_up"
        case userLogin = "user_login"
        case searchMovie = "search_movie"
        case movieDetail = "movie_detail"
    }
}
