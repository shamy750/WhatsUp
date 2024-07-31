//
//  ContentView.swift
//  WhatsUp
//
//  Created by Softsuave on 08/07/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState.shared
    var body: some View {
//        if (appState.isLoggedIn) {
//            SignUpView()
//        } else {
            SignInOrSignUpView()
//        }
    }
}

#Preview {
    ContentView()
}
