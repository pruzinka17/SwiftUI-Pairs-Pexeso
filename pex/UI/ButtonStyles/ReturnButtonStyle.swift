//
//  SettingsButtonStyle.swift
//  pex
//
//  Created by Miroslav Bořek on 13.01.2023.
//

import SwiftUI

struct ReturnButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        
        configuration.label
            .fontWeight(.bold)
            .padding()
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.linear, value: configuration.isPressed)
    }
    
}


