import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseStorage

struct SettingsView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @State private var currentPhotoURL: URL?

    
    @State var user: [UserDetails]
    let signOutAction: () -> Void
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            } else if let currentPhotoURL = URL(string: user[0].profilePictureURL) {
                AsyncImage(url: currentPhotoURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    case .failure:
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .onTapGesture {
                        isImagePickerPresented = true
                    }
            }
            
            Button(action: {
                guard let selectedImage = selectedImage else { return }
                uploadProfilePicture(image: selectedImage) { url in
                    if let url = url {
                        saveProfilePictureURL(userId: user[0].userId, url: url) { success in
                            if success {
                                var updatedUser = user[0]
                                updatedUser.profilePictureURL = url.absoluteString
                                user[0] = updatedUser // Trigger state update
                                currentPhotoURL = url
                            }
                        }
                    }
                }
            }, label: {
                Text("Upload Profile Picture")
            })
            
            Button(action: {
                signOutAction()
            }, label: {
                Text("SignOut")
            })
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .onAppear {
            currentPhotoURL = URL(string: user[0].profilePictureURL)
        }
    }
    
    func saveProfilePictureURL(userId: String, url: URL, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).updateData(["profilePictureURL": url.absoluteString]) { error in
            if let error = error {
                print("Failed to update user profile: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func uploadProfilePicture(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let storageRef = Storage.storage().reference().child("profile_pictures/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                print("Failed to upload image: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    print("Failed to get download URL: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }
                completion(downloadURL)
            }
        }
    }
}
