//
//  MainView.swift
//  WhatsUp
//
//  Created by Softsuave on 12/07/2024.
//

import Foundation
import SwiftUI


struct MainView: View {
    var userDetails: [UserDetails]
    @State private var selectedUser: UserDetails?
    @State private var isChatViewActive = false
    var currentUserId: String // Pass the current user's ID

    var body: some View {
        List(userDetails) { user in
            Button(action: {
                selectedUser = user
                isChatViewActive = true
            }) {
                VStack(alignment: .leading) {
                    Text(user.fullName)
                        .font(.headline)
                    Text(user.email)
                        .font(.subheadline)
                }
            }
        }
        .background(
            NavigationLink(
                destination: selectedUser.map { ChatView(currentUserId: currentUserId, chatPartner: $0) },
                isActive: $isChatViewActive
            ) {
                EmptyView()
            }
        )
    }
}
