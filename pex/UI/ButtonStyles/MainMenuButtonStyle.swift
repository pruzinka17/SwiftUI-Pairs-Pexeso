//
//  MainMenuButtonStyle.swift
//  pex
//
//  Created by Miroslav Bořek on 13.01.2023.
//

import SwiftUI

struct MainMenuButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
 
        configuration.label
            .fontWeight(.bold)
            .padding()
            .background {
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.white)
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.default, value: configuration.isPressed)
    }
}
