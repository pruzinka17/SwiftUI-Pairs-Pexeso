//
//  GameView.swift
//  pex
//
//  Created by Miroslav Bořek on 10.01.2023.
//

import SwiftUI

struct GameView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let gameCardsBuilder: GameCardsBuilder
    let statisticsManager: StatisticsManager
    
    @State private var gameStarted: Bool = false
    @State private var gameFinished: Bool = false
    @State private var isValidatingCards: Bool = false
    
    @State private var cards: [Card] = []
    @State private var foundCards: [String] = []
    @State private var firstSelectedCard: String?
    @State private var secondSelectedCard: String?
    
    @State private var pairsFound: Int = 0
    
    var body: some View {
        
        ZStack {
            
            Image(Constants.backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            GeometryReader { proxy in
                
                let frame = proxy.frame(in: .local)
                let minSize = min(frame.height, frame.width)
                let numberOfCardsPerRow = CGFloat(Constants.numberOfItemsPerRow)
                /// Calculate `numberOfCardsPerRow + 1` to include right padding of Grid
                let spacingPerRow = (numberOfCardsPerRow + 1) * Constants.cardsSpacing
                let itemSize = ((minSize - spacingPerRow) / numberOfCardsPerRow)
                
                VStack () {
                    
                    makeStatisticsBar(proxy: proxy)

//                    Spacer()

                    makeGame(itemSize: itemSize)

                    Spacer()
                    
                    makeFoundCards(proxy: proxy, itemSize: itemSize)
                }
            }
            
            makeEndGame()
        }
        .onAppear {
            
            pairsFound = statisticsManager.providePairsFound()
            
            if !gameStarted {
                
                startNewGame()
            }
        }
    }
}

// MARK: - Game methods

private extension GameView {
    
    @ViewBuilder func makeFoundCards(proxy: GeometryProxy, itemSize: CGFloat) -> some View {
        
        ZStack {
            
            Color.white
                .shadow(radius: 5)
                .ignoresSafeArea()
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack {
                    
                    ForEach(foundCardsPairs()) { card in
                        
                        CardView(
                            model: card,
                            scaleUp: false,
                            isFlippled: true,
                            isDisabled: true,
                            onTap: {}
                        ).frame(width: itemSize, height: itemSize)
                    }
                }
                .frame(height: itemSize)
                .padding([.horizontal, .top])
            }
        }
        .frame(height: itemSize)
        .opacity(foundCards.isEmpty ? 0 : 1)
        .animation(.default, value: foundCards)
    }
    
    @ViewBuilder func makeEndGame() -> some View {
        
        RoundedRectangle(cornerRadius: Constants.EndGame.cornerRadius)
            .foregroundColor(.white)
            .shadow(radius: 5)
            .frame(height: Constants.EndGame.height)
            .padding()
            .overlay {
                
                VStack() {
                    
                    Text(Constants.EndGame.menuTitle)
                        .font(Constants.EndGame.menuTileFont)
                        .padding(.bottom, Constants.EndGame.titleBottomPadding)
                                            
                    Button(Constants.EndGame.newGame) {
                        
                        startNewGame()
                    }
                    .buttonStyle(GameFinishedButtonStyle())
                        
                        
                    Button(Constants.EndGame.close) {
                            
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(GameFinishedButtonStyle())
                }
            }
            .opacity(gameFinished ? 1 : 0)
            .animation(.linear, value: gameFinished)
    }
    
    @ViewBuilder func makeStatisticsBar(proxy: GeometryProxy) -> some View {
        
        ZStack {
            
            Color.white
                .frame(height: proxy.safeAreaInsets.top + 54)
                .shadow(radius: 4)
            
            HStack {
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Label("" , systemImage: "return")
                }
                .buttonStyle(ReturnButtonStyle())
                
                Spacer()

                Text("\(Constants.Statistics.pairsFound) \(pairsFound)")
                    .fontWeight(.bold)

                Spacer()

                Text("\(Constants.Statistics.gamesWon) \(statisticsManager.provideGamesWon())")
                    .fontWeight(.bold)

                Spacer()
            }
            .padding(.top, proxy.safeAreaInsets.top)
        }.ignoresSafeArea()
    }
    
    @ViewBuilder func makeGame(itemSize: CGFloat) -> some View {
        
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                
                ForEach(cards) { card in
                    
                    let isSelected = isCardSelected(card.id)
                    let isFound = isCardFound(card.id)
                    
                    let isFlippled = isSelected || isFound
                    
                    CardView(
                        model: card,
                        scaleUp: isSelected,
                        isFlippled: isFlippled,
                        isDisabled: isFound,
                        onTap: {
                            
                            handleSelection(for: card.id)
                        }
                    )
                    .frame(width: itemSize, height: itemSize)
                    .animation(.linear, value: isValidatingCards)
                    .animation(.linear, value: firstSelectedCard)
                    .animation(.linear, value: secondSelectedCard)
                }
            }
            .padding()
    }
}

// MARK: - Game helpers methods

private extension GameView {
    
    func startNewGame() {
        
        cards = gameCardsBuilder.build()
        gameStarted = true
        gameFinished = false
        foundCards.removeAll()
    }
}

// MARK: - Cards methods

private extension GameView {
    
    func isCardSelected(_ id: String) -> Bool {
        
        return id == firstSelectedCard || id == secondSelectedCard
    }
    
    func isCardFound(_ id: String) -> Bool {
        
        return foundCards.contains(id)
    }
    
    func foundCardsPairs() -> [Card] {
        
        var pairs: [Card] = []
        
        for id in foundCards {
            
            guard
                let card = cards.first(where: { $0.id == id }),
                !pairs.contains(where: { $0.symbol == card.symbol })
            else {
                continue
            }
            
            pairs.append(card)
        }
        
        return pairs.reversed()
        
    }
    
    func handleSelection(for cardId: String) {
        
        guard
            !isValidatingCards,
            !gameFinished,
            !isCardFound(cardId)
        else {
            return
        }
        
        if firstSelectedCard == nil  {
            
            statisticsManager.addCardFlip()
            firstSelectedCard = cardId
            return
        }
        
        if secondSelectedCard == nil, firstSelectedCard != cardId {
            
            statisticsManager.addCardFlip()
            secondSelectedCard = cardId
        }
        
        isValidatingCards = true
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + Constants.validationTimeInterval
        ) {
            
            isValidatingCards = false
            validateCardsSelection()
        }
    }
    
    func validateCardsSelection() {
        
        guard
            let firstCard = cards.first(where: { $0.id == firstSelectedCard }),
            let secondCard = cards.first(where: { $0.id == secondSelectedCard })
        else {
            return
        }
        
        let cardsMatching = firstCard.symbol == secondCard.symbol
        
        switch cardsMatching {
        case true:
            
            foundCards.append(contentsOf: [firstCard.id, secondCard.id])
            
            pairsFound += 1
            statisticsManager.appendPairsFound(pairsFound: pairsFound)
            
            firstSelectedCard = nil
            secondSelectedCard = nil
        case false:
            
            firstSelectedCard = nil
            secondSelectedCard = nil
        }
        
        let allFound = cards.allSatisfy { card in
            
            return foundCards.contains(card.id)
        }
        
        if allFound {
            
            statisticsManager.appendGamesWon()
            
            gameFinished = allFound
        }
    }
}

// MARK: - Constants

private extension GameView {
    
    enum Constants {
        
        static let cardsSpacing: CGFloat = 10
        static let numberOfItemsPerRow: Int = 5
        static let validationTimeInterval: TimeInterval = 0.5
        static let flipAnimationDuration: CGFloat = 0.14
        static let durationAndDelay: CGFloat = 0.15
        
        static let backgroundImage: String = "image-background"
        
        enum EndGame {
            
            static let menuTitle: String = "GAME FINISHED"
            static let newGame: String = "Start New Game"
            static let close: String = "Close"
            
            static let menuTileFont: Font = .system(size: 32, weight: .semibold)
            
            static let cornerRadius: CGFloat = 20
            static let height: CGFloat = 240
            static let titleBottomPadding: CGFloat = 20
            
        }
        
        enum Statistics {
            
            static let pairsFound: String = "Pairs found:"
            static let gamesWon: String = "Games Won:"
        }
    }
}

// MARK: - Array helpers

private extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        
        return stride(from: 0, to: count, by: size).map {
            
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameView(
            gameCardsBuilder: GameCardsBuilder(
                settingsManager: SettingsManager()
            ),
            statisticsManager: StatisticsManager()
        )//.previewInterfaceOrientation(.landscapeLeft)
    }
}
