import SwiftUI
import FirebaseFirestore

struct ChatView: View {
    @State private var newMessage = ""
    @State private var messages = [ChatMessage]()
    var currentUserId: String
    var chatPartner: UserDetails

    var body: some View {
        VStack {
            List(messages) { message in
                HStack {
                    if message.senderId == currentUserId {
                        Spacer()
                        Text(message.text)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    } else {
                        Text(message.text)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        Spacer()
                    }
                }
            }
            .onAppear {
                setupListeners()
            }

            HStack {
                TextField("Message...", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)

                Button(action: {
                    sendMessage()
                }) {
                    Text("Send")
                }
            }
            .padding()
        }
        .navigationTitle(chatPartner.fullName)
    }

    func setupListeners() {
        let db = Firestore.firestore()

        db.collection("chats")
            .whereField("participants", arrayContains: currentUserId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    if let querySnapshot = querySnapshot {
                        do {
                            let newMessages = try querySnapshot.documents.compactMap { document in
                                try document.data(as: ChatMessage.self)
                            }
                            self.updateMessages(newMessages)
                        } catch {
                            print("Error decoding documents: \(error)")
                        }
                    }
                }
            }
    }

    private func updateMessages(_ newMessages: [ChatMessage]) {
        DispatchQueue.main.async {
            self.messages = newMessages
            self.messages.sort { $0.timestamp < $1.timestamp }
        }
    }

    func sendMessage() {
        let db = Firestore.firestore()
        let newChatMessage = ChatMessage(senderId: currentUserId, receiverId: chatPartner.userId, text: newMessage, timestamp: Date())
        do {
            _ = try db.collection("chats").addDocument(from: newChatMessage)
            newMessage = ""
        } catch {
            print("Error adding document: \(error)")
        }
    }
}
