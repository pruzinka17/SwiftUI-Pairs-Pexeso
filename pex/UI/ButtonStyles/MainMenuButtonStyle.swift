//
//  MainMenuButtonStyle.swift
//  pex
//
//  Created by Miroslav Bořek on 13.01.2023.
//

import SwiftUI

struct MainMenuButtonStyle: ButtonStyle {
    
    var buttonWidth: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
 
        configuration.label
            .frame(width: buttonWidth)
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
