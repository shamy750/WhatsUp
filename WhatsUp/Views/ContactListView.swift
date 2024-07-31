//
//  MainView.swift
//  WhatsUp
//
//  Created by Softsuave on 12/07/2024.
//

import Foundation
import SwiftUI
import CryptoKit
import FirebaseFirestore
import Firebase



struct ContactListView: View {
    var userDetails: [UserDetails]
    @State private var selectedUser: UserDetails?
    @State private var isChatViewActive = false
    @State private var messages: [Message] = []
    var currentUserId: String // Pass the current user's ID

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(userDetails) { user in
                    if user.userId != currentUserId {
                        CellView(image: "person.fill", contact: user.fullName, lastMessage: "How are you", user: user)
                            .onTapGesture {
                                selectedUser = user
                                isChatViewActive = true
                            }
                    }
                    
                }
            }
        }
        
                .background(
                    NavigationLink(
                        destination: selectedUser.map { ChatScreenView(chatRoomId: createChatRoomId(userId1: currentUserId, userId2: selectedUser?.userId ?? ""), currentUserId: currentUserId, currentUserDetails: userDetails.filter{ user in  user.userId == currentUserId }, chatPartner: $0) },
                        isActive: $isChatViewActive
                    ) {
                        EmptyView()
                    }
                )
        }

    
    
    func createChatRoomId(userId1: String, userId2: String) -> String {
        let combinedString = [userId1, userId2].sorted().joined(separator: "_")
        let hash = SHA256.hash(data: Data(combinedString.utf8))
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
