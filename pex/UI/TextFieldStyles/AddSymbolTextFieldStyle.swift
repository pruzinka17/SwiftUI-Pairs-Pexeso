//
//  AddSymlobTextFieldStyle.swift
//  pex
//
//  Created by Miroslav Bořek on 19.01.2023.
//

import SwiftUI

struct AddSymbolTextFieldStyle: TextFieldStyle {
    
    var isValid: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        
        configuration
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .padding()
            .background(content: {

                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(isValid ? Color(red: 0.96, green: 0.96, blue: 0.96) : Color(red: 0.99, green: 0.5, blue: 0.5))
                    .overlay(
                        
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isValid ? Color(red: 0.68, green: 0.68, blue: 0.68) : Color(red: 0.99, green: 0.4, blue: 0.4), lineWidth: 2)
                    )
            })
            .shadow(radius: 8)
            .font(.system(size: 60))
            .frame(width: 95)
    }
}
