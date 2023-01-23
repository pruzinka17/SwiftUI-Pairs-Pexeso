//
//  SettingsManager.swift
//  pex
//
//  Created by Miroslav Bořek on 16.01.2023.
//

import Foundation

final class SettingsManager {
    
    private let userDefaults: UserDefaults
    
    init() {
        
        self.userDefaults = .standard
    }
    
    func provideSymbols() -> [String] {
        
        let symbols = userDefaults.object(forKey: Defaults.symbolsKey) as? [String]
        return symbols ?? []
    }
    
    func createNewSymbol(_ symbol: String) {
        
        var symbols = provideSymbols()
        symbols.append(symbol)
        
        userDefaults.set(symbols, forKey: Defaults.symbolsKey)
    }
    
    func deleteSymbol(_ symbol: String) {
        
        var symbols = provideSymbols()
        symbols.removeAll { $0 == symbol }
        
        userDefaults.set(symbols, forKey: Defaults.symbolsKey)
    }
}

// MARK: - Defaults

private extension SettingsManager {
    
    enum Defaults {
        
        static let symbolsKey = "pexos.symbols"
    }
}

