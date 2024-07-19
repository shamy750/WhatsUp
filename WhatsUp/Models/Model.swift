//
//  Model.swift
//  WhatsUp
//
//  Created by Softsuave on 15/07/2024.
//

import FirebaseFirestore

struct UserDetails: Codable, Identifiable {
   @DocumentID var id: String?
    var userId: String
    var email: String
    var fullName: String
}

struct ChatMessage: Identifiable, Codable {
    @DocumentID var id: String?
    var senderId: String
    var receiverId: String
    var text: String
    var timestamp: Date
}
