//
//  UserDefaults.swift
//  WhatsUp
//
//  Created by Softsuave on 19/07/2024.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var isLoggedIn: Bool
    
    private init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn)
    }
}

struct UserDefaultsKeys {
    static let userId = "userId"
    static let email = "username"
    static let isLoggedIn = "isLoggedIn"
    static let fullName = "fullName"
}
