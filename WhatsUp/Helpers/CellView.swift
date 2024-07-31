//
//  CellView.swift
//  WhatsUp
//
//  Created by Softsuave on 24/07/2024.
//

import SwiftUI

struct CellView: View {
    var image: String = "person.fill"
    var contact: String = "Contact Name"
    var lastMessage: String = "Last message preview..."
    var timestamp: String = "Now"
    @State var user: UserDetails
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(radius: 5)
                    .frame(height: 80)
                    .padding(.horizontal)
                   
                
                HStack {

                    
                    if let currentPhotoURL = URL(string: user.profilePictureURL) {
                        AsyncImage(url: currentPhotoURL) { phase in
                            switch phase {
                            case .empty:
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                 
                            case .failure:
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                              
                            @unknown default:
                                EmptyView()
                            }
                        }.padding(.leading, 10)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(25)
                            .padding(.leading, 10)
                    }

                        
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(contact)
                            .font(.headline)
                            .foregroundColor(.black)
                               
//                        Text(lastMessage)
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                            .lineLimit(1)
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
//                    VStack {
//                        Text(timestamp)
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        
//                    }
//                    .padding(.trailing, 20)
                }.padding()
            }
        }
    }
}

//#Preview {
//    CellView()
//}
