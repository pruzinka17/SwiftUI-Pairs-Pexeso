//
//  SettingsView.swift
//  pex
//
//  Created by Miroslav Bořek on 13.01.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let settingsManager: SettingsManager
    
    @State private var symbols: [String] = []
    
    @State private var isPresentingAddCard: Bool = false
    
    @State private var numberOfCards: Int = 0
    
    var body: some View {
        
        ZStack {
            
            Image(Constants.backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            makeSettings()
                .onAppear {
                    
                    getCards()
                }
        }
        .fullScreenCover(
            isPresented: $isPresentingAddCard,
            onDismiss: {
                
                getCards()
            }, content: {
                
                AddCardView(settingsManager: settingsManager)
            }
        )
    }
}

// MARK: - Settings Views

private extension SettingsView {
    
    @ViewBuilder func makeSettings() -> some View {
        
        VStack {
            
            makeTopBar()
            
            makeSymbolStack()
            
            makeBottomBar()
        }
    }
    
    @ViewBuilder func makeTopBar() -> some View {
        
        HStack {
            
            Button {
                
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("", systemImage: "return")
            }
            .buttonStyle(ReturnButtonStyle())
            
            Spacer()
            
            Text("\(Constants.settingTitle) \(provideCardStatistics())")
                .fontWeight(.bold)
                .padding(.leading, -60)
            
            Spacer()
            
        }
    }
    
    @ViewBuilder func makeSymbolStack() -> some View {
        
        let gridColumns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        ScrollView {
            
            LazyVGrid(columns: gridColumns) {
                
                ForEach(symbols, id: \.description ) { symbol in
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.92))
                        .frame(width: 75, height: 75)
                        .shadow(radius: 4)
                        .overlay {
                            Text(symbol)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                
                                withAnimation {
                                    
                                    settingsManager.deleteSymbol(symbol)
                                    getCards()
                                }
                            } label: {
                                
                                Label(Constants.removeCardsTitle, systemImage: "trash.fill")
                            }
                            
                        }
                }
            }
        }
        .padding()
    }
    
    @ViewBuilder func makeBottomBar() -> some View {
        
        Button {
            
            isPresentingAddCard = true
        } label: {
            
            Label(Constants.addCardTitle, systemImage: "plus.app")
        }
        .opacity((numberOfCards < Constants.maximumNumberOfCards) ? 1 : 0.3)
        .disabled((numberOfCards < Constants.maximumNumberOfCards) ? false : true)
        .buttonStyle(ReturnButtonStyle())
    }
}

// MARK: - Helper funcitons

private extension SettingsView {
    
    func getCards() {
        
        symbols = settingsManager.provideSymbols()
        numberOfCards = symbols.count
    }
    
    func provideCardStatistics() -> String {
        
        return "\(numberOfCards)/\(Constants.maximumNumberOfCards)"
    }
}

// MARK: - Constants

private extension SettingsView {
    
    enum Constants {
            
            static let maximumNumberOfCards = 12
            
            static let settingTitle: String = "Your Emojis"
            static let addCardTitle: String = "Add Card"
            static let removeCardsTitle: String = "Remove"
            static let backgroundImage: String = "image-background"
    }
}

struct SettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SettingsView(settingsManager: SettingsManager())
    }
}
