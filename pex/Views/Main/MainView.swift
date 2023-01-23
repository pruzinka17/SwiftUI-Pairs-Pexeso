//
//  MainView.swift
//  pex
//
//  Created by Miroslav Bořek on 13.01.2023.
//

import SwiftUI

struct MainView: View {
    
    let settingsManager: SettingsManager
    let statisticsManager: StatisticsManager
    
    @State private var isPresentingGame: Bool = false
    @State private var isPresentingSettings: Bool = false
    @State private var isPresentingStatistics: Bool = false
    
    var body: some View {
        
        ZStack {
        
            Image(Constants.backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            makeContent()
        }
        .fullScreenCover(isPresented: $isPresentingGame) {
            
            GameView(
                gameCardsBuilder: GameCardsBuilder(settingsManager: settingsManager),
                statisticsManager: statisticsManager
            )
        }
        .fullScreenCover(isPresented: $isPresentingSettings) {
            
            SettingsView(settingsManager: settingsManager)
        }
        .fullScreenCover(isPresented: $isPresentingStatistics) {
            
            StatisticsView(statisticsManager: statisticsManager)
        }
    }
}

// MARK: - Content methods

private extension MainView {
    
    @ViewBuilder func makeContent() -> some View {
        
        VStack() {
            
            Spacer()
                            
            Text(Constants.title)
                .font(Constants.titleFont)
                .foregroundColor(.white)
            
            Spacer()
            
            makeMenu()
        }
    }
    
    @ViewBuilder func makeMenu() -> some View {
        
        VStack(spacing: 30) {
            
            HStack(spacing: Constants.Menu.horizontalSpacing) {
             
                Button(Constants.Menu.newGameTitle) {
                    
                    isPresentingGame = true
                }
                .buttonStyle(MainMenuButtonStyle())
                
                Button(Constants.Menu.settingsTitle) {
                    
                    isPresentingSettings = true
                }.buttonStyle(MainMenuButtonStyle())
            }
            
            HStack {
                
                Button(Constants.Menu.statisticsTitle) {
                    
                    isPresentingStatistics = true
                }.buttonStyle(MainMenuButtonStyle())
            }
        }
        .padding()
    }
}

// MARK: - Constants

private extension MainView {
    
    enum Constants {
        
        static let backgroundImage: String = "image-background"
        static let title: String = "pexeso"
        static let titleFont: Font = .system(size: 60, weight: .ultraLight)
        static let verticalSpacing: CGFloat = 110
        
        enum Menu {
            
            static let newGameTitle: String = "New Game"
            static let settingsTitle: String = "Settings"
            static let statisticsTitle: String = "Statistics"
            
            static let buttonCornerRadius: CGFloat = 20
            
            static let horizontalSpacing:CGFloat = 50
        }
    }
}

struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        MainView(
            settingsManager: SettingsManager(),
            statisticsManager: StatisticsManager()
        )
    }
}
