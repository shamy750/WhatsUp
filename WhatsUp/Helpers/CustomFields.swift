//
//  CustomFields.swift
//  WhatsUp
//
//  Created by Softsuave on 17/07/2024.
//

import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color.white)
                    .opacity(0.5)
                    .frame(height: 50)
                
                TextField(placeholder, text: $text)
                    .padding(.leading, 30)
            }
        }
        
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color.white)
                    .opacity(0.5)
                    .frame(height: 50)
                
                SecureField(placeholder, text: $text)
                    .padding(.leading, 30)
            }
        }
        
    }
}
