//
//  GameCardsBuilder.swift
//  pex
//
//  Created by Miroslav Bořek on 10.01.2023.
//

import Foundation

final class GameCardsBuilder {
    
    let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager) {
        
        self.settingsManager = settingsManager
    }
    
    func build() -> [Card] {
        
        var cards: [Card] = []
        
        let symbols: [String] = settingsManager.provideSymbols()
        
        for symbol in symbols {
            
            let firstCard = Card(
                id: UUID().uuidString,
                symbol: symbol
            )
            
            let secondCard = Card(
                id: UUID().uuidString,
                symbol: symbol
            )
            
            cards.append(contentsOf: [firstCard, secondCard])
        }
        
        return cards.shuffled()
    }
}
