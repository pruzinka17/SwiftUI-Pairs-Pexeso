//
//  StatisticsManager.swift
//  pex
//
//  Created by Miroslav Bořek on 19.01.2023.
//

import Foundation

final class StatisticsManager {
    
    private let userDefauts: UserDefaults
    
    init() {
        
        self.userDefauts = .standard
    }
    
    func resetAllStatistics() {
        
        userDefauts.set(0, forKey: Defaults.cardsFlippedKey)
        userDefauts.set(0, forKey: Defaults.pairsFoundKey)
        userDefauts.set(0, forKey: Defaults.gamesWonKey)
    }
    
    func provideGamesWon() -> Int {
        
        let gamesWon = userDefauts.integer(forKey: Defaults.gamesWonKey)
        return gamesWon
    }
    
    func appendGamesWon() {
        
        let gamesWon = provideGamesWon() + 1
        userDefauts.set(gamesWon, forKey: Defaults.gamesWonKey)
    }
    
    func providePairsFound() -> Int {
        
        let pairsFound = userDefauts.integer(forKey: Defaults.pairsFoundKey)
        return pairsFound
    }
    
    func appendPairsFound(pairsFound: Int) {

        userDefauts.set(pairsFound, forKey: Defaults.pairsFoundKey)
    }
    
    func provideCardFlips() -> Int {
        
        let cardFlips = userDefauts.integer(forKey: Defaults.cardsFlippedKey)
        return cardFlips
    }
    
    func addCardFlip() {
        
        let cardsFlips = provideCardFlips() + 1
        userDefauts.set(cardsFlips, forKey: Defaults.cardsFlippedKey)
    }
}

// MARK: - Defaults

private extension StatisticsManager {
    
    enum Defaults {
        
        static let gamesWonKey = "pexos.gameswon"
        static let pairsFoundKey = "pexos.pairsfound"
        static let cardsFlippedKey = "pexos.cardsflipped"
    }
}
