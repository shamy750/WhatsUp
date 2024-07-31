//
//  SignUpView.swift
//  WhatsUp
//
//  Created by Softsuave on 08/07/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    
    @State var email: String = ""
    @State var userName: String = ""
    @State var password: String = ""
    @State var isSignedUp: Bool = false
    @State var isValid: Bool = true
    @State var alert: String = ""
    @State var showAlert: Bool = false
    @State var isSignedIn: Bool = false
    @State var currentUserId : String = ""
    @State var loggenUserName: [UserDetails] = [UserDetails]()
    
    @State private var userDetails = [UserDetails]()
    
    let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            if isSignedIn {
                TabView {
                    ContactListView(userDetails: userDetails, currentUserId: currentUserId)
                        .tabItem {
                            Label("Chat", systemImage: "message")
                        }
                    
                    SettingsView(user: userDetails.filter { $0.userId == currentUserId }, signOutAction: signOut)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                }
            } else {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    
                    VStack {
                        Image("ChatImage")
                            .resizable()
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .padding()
                        
                        Text(isSignedUp ? "SignIn" : "SignUp")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .foregroundStyle(Color.white)
                        
                        if !isSignedUp {
                            CustomTextField(placeholder: "Name", text: $userName)
                                .padding(.bottom, 10)
                        }
                        CustomTextField(placeholder: "Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .padding(.bottom, 10)
                        CustomSecureField(placeholder: "Password", text: $password)
                            .padding(.bottom, 10)
                        Button(action: {
                            isSignedUp ? signIn(email: email, password: password) : createNewUser(name: userName, email: email, pass: password) { status, result in
                                if status {
                                    alert = "SignUp successfull"
                                    showAlert = true
                                    isSignedUp = true
                                }
                            }
                        }, label: {
                            Text(isSignedUp ? "SignIn" : "SignUp")
                        })
                        .frame(width: 100, height: 100)
                        .background(Color.black)
                        .cornerRadius(10)
                        .foregroundColor(Color.white)
                        Button(action: {
                            isSignedUp = !isSignedUp
                        }, label: {Text(isSignedUp ? "SignUp" : "SignIn" )})
                    }
                    .padding()
                }
                .onAppear {
                    fetchUsers()
                    checkLoginState()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Alert"),
                        message: Text(alert),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func createNewUser(name: String, email: String, pass: String, completionHandler: @escaping (_ result: Bool, _ errorMessage: String) -> Void) {
        if validateName() {
            Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
                do {
                    if let error = error {
                        throw error
                    }
                    guard let user = authResult?.user else {
                        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not found"])
                    }
                    
                    self.db.collection("users").document(user.uid).setData([
                        "userId": user.uid,
                        "fullName": name,
                        "email": email,
                        "profilePictureURL": ""
                    ])
                    completionHandler(true, "Signup is successful")
                } catch {
                    completionHandler(false, error.localizedDescription)
                    print("error signUp : \(error.localizedDescription)")
                    alert = "error signUp : \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                alert = "Error signing in: \(error.localizedDescription)"
                showAlert = true
            } else if let user = authResult?.user {
                isSignedIn = true
                currentUserId = user.uid
                loggenUserName = userDetails.filter { $0.userId == currentUserId }
                print(loggenUserName, "userddh")
                setUserDefaults()
                AppState.shared.isLoggedIn = true
            }
        }
    }
    
    func validateName() -> Bool {
        if userName.isEmpty || userName == "" {
            alert = "Please enter an user Name"
            showAlert = true
            return false
        }
        return true
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            clearUserDefaults()
            isSignedIn = false
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func setUserDefaults() {
        UserDefaults.standard.set(currentUserId, forKey: UserDefaultsKeys.userId)
        UserDefaults.standard.set(email, forKey: UserDefaultsKeys.email)
        UserDefaults.standard.set(loggenUserName.first?.fullName, forKey: UserDefaultsKeys.fullName)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isLoggedIn)
    }
    
    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userId)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.email)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.fullName)
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isLoggedIn)
    }
    
    func checkLoginState() {
        let isLoggedIn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn)
        if isLoggedIn && isSignedUp {
            currentUserId = UserDefaults.standard.string(forKey: UserDefaultsKeys.userId) ?? ""
            email = UserDefaults.standard.string(forKey: UserDefaultsKeys.email) ?? ""
            isSignedIn = true
        }
    }
    
    func fetchUsers() {
        let db = Firestore.firestore()
        db.collection("users").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                if let querySnapshot = querySnapshot {
                    do {
                        userDetails = try querySnapshot.documents.compactMap { document in
                            try document.data(as: UserDetails.self)
                        }
                        print(userDetails)
                    } catch {
                        print("Error decoding documents: \(error)")
                    }
                }
            }
        }
    }
}


#Preview {
    SignUpView()
}
