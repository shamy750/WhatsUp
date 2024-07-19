//
//  SignInOrSignUpView.swift
//  WhatsUp
//
//  Created by Softsuave on 09/07/2024.
//

import Foundation
import SwiftUI


struct SignInOrSignUpView : View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.purple]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(height: 400)
                        .padding()
                    VStack {
                        
                        Image("ChatImage")
                            .resizable()
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .padding()
                        
                        Text("Welcome to ChatBox")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .padding()
                        
                        HStack(spacing: 20) {
                            
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up")
                                    .frame(width: 100)
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: SignUpView(isSignedUp: true)) {
                                Text("Sign In")
                                    .frame(width: 100)
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
        }
    }

}
