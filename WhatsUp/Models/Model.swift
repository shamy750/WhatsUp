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
    var profilePictureURL: String
}



struct Message: Identifiable {
    var id: String = UUID().uuidString
    var senderId: String
    var receiverId: String
    var message: String
    var timestamp: Date
}
