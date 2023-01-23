//
//  ContentView.swift
//  pex
//
//  Created by Miroslav Bořek on 10.01.2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        MainView(
            settingsManager: SettingsManager(),
            statisticsManager: StatisticsManager()
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ContentView()
    }
}
