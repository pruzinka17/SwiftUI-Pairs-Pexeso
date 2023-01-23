//
//  CardView.swift
//  pex
//
//  Created by Miroslav Bořek on 11.01.2023.
//

import SwiftUI

struct CardView: View {
    
    let model: Card
    let scaleUp: Bool
    let isFlippled: Bool
    let isDisabled: Bool
    
    let onTap: () -> Void
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .scale(scaleUp ? 1.2 : 1)
                .foregroundColor(.clear)
                .background(content: {
                    
//                    LinearGradient(
//                        colors: [Color(red: 0.65, green: 0.65, blue: 0.65), Color(red: 0.78, green: 0.78, blue: 0.78)],
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
                    Color(red: 0.92, green: 0.92, blue: 0.92)
                    .cornerRadius(10)
                })
                .opacity(isDisabled ? 0.5 : 1)
                .rotation3DEffect(Angle(degrees: isFlippled ? 90 : 0), axis: (x: 0, y: 1, z: 0))
                .animation(.linear(duration: 0.2).delay(!isFlippled ? 0.2 : 0), value: isFlippled)
            
            RoundedRectangle(cornerRadius: 10)
                .scale(scaleUp ? 1.1 : 1)
                .foregroundColor(.clear)
                .background(content: {
                    
//                    LinearGradient(
//                        colors: [Color(red: 0.65, green: 0.65, blue: 0.65), Color(red: 0.78, green: 0.78, blue: 0.78)],
//                        startPoint: .topTrailing,
//                        endPoint: .bottomLeading
//                    )
                    Color(red: 0.92, green: 0.92, blue: 0.92)
                    .cornerRadius(10)
                })
                .opacity(isDisabled ? 0.5 : 1)
                .overlay {
                    
                    Text(model.symbol)
                        .font(.system(size: 32))
                }
                    .rotation3DEffect(Angle(degrees: isFlippled ? 0 : -90), axis: (x: 0, y: 1, z: 0))
                    .animation(.linear(duration: 0.2).delay(isFlippled ? 0.2 : 0), value: isFlippled)
        }
        .onTapGesture {
            
            onTap()
        }
    }
}
