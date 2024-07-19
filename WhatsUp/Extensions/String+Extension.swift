//
//  String+Extension.swift
//  WhatsUp
//
//  Created by Softsuave on 09/07/2024.
//

import Foundation

extension String {
    
    /// email validation
    /// - Returns: true/false
    func isValidEmail() -> Bool {
        // Regular expression pattern for validating email addresses
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        
        // Create NSPredicate with the email regex
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        
        // Test the predicate with the email string
        return emailPredicate.evaluate(with: self)
    }
    
    /// Password validation
    /// - Returns: true/false
    func isValidPassword() -> Bool {
        return self.count >= 6
    }
}
