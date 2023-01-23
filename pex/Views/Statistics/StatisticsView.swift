//
//  StatisticsView.swift
//  pex
//
//  Created by Miroslav Bořek on 19.01.2023.
//

import SwiftUI

struct StatisticsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let statisticsManager: StatisticsManager
    
    @State private var gamesWon: Int = 0
    @State private var pairsFound: Int = 0
    @State private var cardFlips: Int = 0
    
    var body: some View {
        
        ZStack {
            
            Image(Constants.backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                topBar()
                
                Spacer()
                
                statistics()
                
                Spacer()
                
            }
        }
        .onAppear {
            getAllData()
        }
    }
}

// MARK: - Helper functions

private extension StatisticsView {
    
    func getAllData() {
        
        gamesWon = statisticsManager.provideGamesWon()
        pairsFound = statisticsManager.providePairsFound()
        cardFlips = statisticsManager.provideCardFlips()
    }
    
    func resetStatistics() {
        
        statisticsManager.resetAllStatistics()
        getAllData()
    }
}

// MARK: - StatisticsView methods

private extension StatisticsView {
    
    @ViewBuilder func topBar() -> some View {
        
        HStack {
            
            Button {
                
                presentationMode.wrappedValue.dismiss()
            } label: {
                
                Label("", systemImage: "return")
            }.buttonStyle(ReturnButtonStyle())

            Spacer()
            
            Menu {
                Button(Constants.resetButtonTitle) {
                    
                    resetStatistics()
                }
            } label: {
                
                Label("", systemImage: "slider.horizontal.3")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
            }

        }
    }
    
    @ViewBuilder func statistics() -> some View {
        
        VStack (spacing: 60) {
            
            Text("\(Constants.gamesWonTitle) \(gamesWon)")
                .fontWeight(.bold)
            
            Text("\(Constants.pairsFoundTitle) \(pairsFound)")
                .fontWeight(.bold)
            
            Text("\(Constants.cardFlips) \(cardFlips)")
                .fontWeight(.bold)
        }
    }
}

// MARK: - Constants

private extension StatisticsView {
    
    enum Constants {
        
        static let backgroundImage = "image-background"
        static let gamesWonTitle = "Games Won:"
        static let pairsFoundTitle = "Pairs Found:"
        static let resetButtonTitle = "Reset Statistics"
        static let cardFlips = "Cards Flipped:"
    }
}

struct StatisticsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        StatisticsView(
            statisticsManager: StatisticsManager()
        )
    }
}
