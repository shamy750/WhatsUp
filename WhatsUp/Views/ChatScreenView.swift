import SwiftUI
import FirebaseFirestore
import Firebase

struct ChatScreenView: View {
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    let chatRoomId: String
    let currentUserId: String
    let currentUserDetails : [UserDetails]
    var chatPartner: UserDetails
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        if #available(iOS 16.0, *) {
            VStack {
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack {
                            ForEach(messages) { message in
                                HStack {
                                    if message.senderId == currentUserId {
                                        Spacer()
                                        VStack {
                                            Text(message.message)
                                                .padding()
                                                .background(Color.blue)
                                                .cornerRadius(15)
                                                .foregroundColor(.white)
                                                .shadow(radius: 2)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                    } else {
                                        Text(message.message)
                                            .padding()
                                            .background(Color.gray.opacity(0.5))
                                            .cornerRadius(15)
                                            .foregroundColor(.black)
                                            .shadow(radius: 2)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        Spacer()
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            }
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                .padding(.top)
                
                
                HStack {
                    TextField("Message...", text: $newMessage)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .frame(minHeight: 30)
                    
                    Button(action: {
                        sendMessage(chatRoomId: chatRoomId, senderId: currentUserId, receiverId: "receiverId", message: newMessage)
                        print("chatroomID:", chatRoomId)
                        newMessage = ""
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(50)
                    }.disabled(newMessage.isEmpty)
                }
                .padding()
                
            }
            .navigationBarBackButtonHidden(true)
            //        .navigationBarItems(leading:
            //                                HStack {
            //            Button(action: {
            //                presentationMode.wrappedValue.dismiss()
            //            }) {
            //                HStack {
            //                    Image(systemName: "arrow.left")
            //                }
            //            }
            //            Spacer()
            //            
            //            if let currentPhotoURL = URL(string: chatPartner.profilePictureURL) {
            //                AsyncImage(url: currentPhotoURL) { phase in
            //                    switch phase {
            //                    case .empty:
            //                        Image(systemName: "person.circle.fill")
            //                            .resizable()
            //                            .scaledToFill()
            //                            .aspectRatio(contentMode: .fill)
            //                            .frame(width: 50, height: 50)
            //                            .clipShape(Circle())
            //                        
            //                    case .success(let image):
            //                        image
            //                            .resizable()
            //                            .scaledToFill()
            //                            .aspectRatio(contentMode: .fill)
            //                            .frame(width: 50, height: 50)
            //                            .clipShape(Circle())
            //                        
            //                    case .failure:
            //                        Image(systemName: "person.circle.fill")
            //                            .resizable()
            //                            .scaledToFill()
            //                            .aspectRatio(contentMode: .fill)
            //                            .frame(width: 50, height: 50)
            //                            .clipShape(Circle())
            //                        
            //                    @unknown default:
            //                        EmptyView()
            //                    }
            //                }
            //            } else {
            //                Image(systemName: "person.circle.fill")
            //                    .resizable()
            //                    .scaledToFill()
            //                    .aspectRatio(contentMode: .fill)
            //                    .frame(width: 50, height: 50)
            //                    .clipShape(Circle())
            //            }
            //            Text(chatPartner.fullName)
            //                .font(.headline)
            //                .foregroundColor(.primary)
            //            
            //            
            //        })
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 5) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "arrow.left")
                            }
                        }
                        if let currentPhotoURL = URL(string: chatPartner.profilePictureURL) {
                            AsyncImage(url: currentPhotoURL) { phase in
                                switch phase {
                                case .empty:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .padding(.bottom ,10)
                                    
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .padding(.bottom ,10)
                                    
                                case .failure:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .padding(.bottom ,10)
                                    
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.bottom ,10)
                        }
                        
                        Text(chatPartner.fullName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding([.leading, .bottom], 10)
                        
                    }
                }
            }   .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                
            
            
                .onAppear {
                    listenForMessages(chatRoomId: chatRoomId) { messages in
                        self.messages = messages
                    }
                }
        } else {
            // Fallback on earlier versions
        }
    }
}

func listenForMessages(chatRoomId: String, completionHandler: @escaping (_ messages: [Message]) -> Void) {
    let db = Firestore.firestore()
    db.collection("chats").document(chatRoomId).collection("messages")
        .order(by: "timestamp", descending: false)
        .addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("No messages found")
                return
            }
            var messages: [Message] = []
            for document in documents {
                let data = document.data()
                let senderId = data["senderId"] as? String ?? ""
                let receiverId = data["receiverId"] as? String ?? ""
                let message = data["message"] as? String ?? ""
                let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                let messageObject = Message(senderId: senderId, receiverId: receiverId, message: message, timestamp: timestamp.dateValue())
                messages.append(messageObject)
            }
            completionHandler(messages)
        }
}



func sendMessage(chatRoomId: String, senderId: String, receiverId: String, message: String) {
    let db = Firestore.firestore()
    let messageData: [String: Any] = [
        "senderId": senderId,
        "receiverId": receiverId,
        "message": message,
        "timestamp": Timestamp(date: Date())
    ]
    db.collection("chats").document(chatRoomId).collection("messages").addDocument(data: messageData) { error in
        if let error = error {
            print("Error sending message: \(error.localizedDescription)")
        } else {
            print("Message sent successfully!")
        }
    }
}
