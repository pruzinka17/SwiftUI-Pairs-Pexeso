//
//  AddCardButtonStyle.swift
//  pex
//
//  Created by Miroslav Bořek on 19.01.2023.
//

import SwiftUI

struct AddCardButtonStyle: ButtonStyle {
    
    @Binding var isSymbolValid: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .fontWeight(.bold)
            .padding()
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.linear, value: configuration.isPressed)
            .opacity(isSymbolValid ? 1 : 0.4)
            .padding(.bottom, 15)
    }
    
}
