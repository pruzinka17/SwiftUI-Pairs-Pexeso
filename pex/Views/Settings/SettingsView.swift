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
            
            makeContent()
        }
        .onAppear {
            
            updateCards()
        }
        .fullScreenCover(
            isPresented: $isPresentingAddCard,
            onDismiss: {
                
                updateCards()
            }, content: {
                
                AddCardView(settingsManager: settingsManager)
            }
        )
    }
}

// MARK: - Views methods

private extension SettingsView {
    
    @ViewBuilder func makeContent() -> some View {
            
            VStack {
                
                makeTopBar()
                
                GeometryReader { proxy in
                    
                    let frame = proxy.frame(in: .local)
                    let width = frame.width
                    let itemSize = width / Constants.itemsPerRow - Constants.itemsSpacing
                    
                    makeSymbolStack(itemSize: itemSize)
                }
                
                
                makeBottomBar()
            }
    }
    
    @ViewBuilder func makeTopBar() -> some View {
        
        ZStack {
            
            HStack {
                
                Button {
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("", systemImage: "return")
                }
                .buttonStyle(ReturnButtonStyle())
                
                Spacer()
            }
            
            HStack {
                
                Text("\(Constants.settingTitle) \(provideCardStatistics())")
                    .fontWeight(.bold)
            }
        }
    }
    
    @ViewBuilder func makeSymbolStack(itemSize: CGFloat) -> some View {
        
        let gridColumns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        ScrollView {
            
            LazyVGrid(columns: gridColumns) {
                
                ForEach(symbols, id: \.description ) { symbol in
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(red: 0.92, green: 0.92, blue: 0.92))
                        .frame(width: itemSize, height: itemSize)
                        .shadow(radius: 4)
                        .overlay {
                            
                            Text(symbol)
                        }
                        .contextMenu {
                            
                            Button(role: .destructive) {
                                
                                withAnimation {
                                    
                                    settingsManager.deleteSymbol(symbol)
                                    updateCards()
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
        
        let isButtonEnabled = numberOfCards < Constants.maximumNumberOfCards
        
        Button {
            
            isPresentingAddCard = true
        } label: {
            
            Label(Constants.addCardTitle, systemImage: "plus.app")
        }
        .opacity(isButtonEnabled ? 1 : 0.3)
        .disabled(!isButtonEnabled)
        .buttonStyle(ReturnButtonStyle())
    }
}

// MARK: - Helper funcitons

private extension SettingsView {
    
    func updateCards() {
        
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
        
        static let itemsPerRow: CGFloat = 4
        static let itemsSpacing: CGFloat = 25
            
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
