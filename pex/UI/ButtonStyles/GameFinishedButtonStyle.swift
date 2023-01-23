//
//  GameFinishedButtonStyle.swift
//  pex
//
//  Created by Miroslav Bořek on 13.01.2023.
//

import SwiftUI

struct GameFinishedButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .fontWeight(.medium)
            .padding()
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.linear, value: configuration.isPressed)
            .background {
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.gray)
                    .opacity(0.1)
                
            }
    }
}
