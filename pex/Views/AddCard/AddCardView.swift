//
//  AddCardView.swift
//  pex
//
//  Created by Miroslav Bořek on 16.01.2023.
//

import SwiftUI

struct AddCardView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    let settingsManager: SettingsManager
    
    @State private var symbol = ""
    @State private var isSymbolValid = false
    @State private var notification = ""
    
    @FocusState private var inFocus: Bool
    
    var body: some View {
        
        ZStack {
            
//            LinearGradient(colors: [.orange, .clear], startPoint: .top, endPoint: .bottom)
//                .ignoresSafeArea()
            
            Image(Constants.backgroundImage)
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                topBar()
                
                Spacer()
                
                userInput()
                
                Spacer()
                
                bottomBar()
            }
        }.onChange(of: symbol) { newValue in
            
            validateInput()
        }.onAppear {
            inFocus = true
        }
    }
}

// MARK: - AddCard methods

private extension AddCardView {
    
    @ViewBuilder func topBar() -> some View {
        
        HStack {
            
            Button {
                
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("", systemImage: "return")
            }
            .buttonStyle(ReturnButtonStyle())
            
            Spacer()
            
            Text(Constants.AddCard.title)
                .fontWeight(.bold)
                .padding(.leading, -60)
            
            Spacer()
        }
    }
    
    @ViewBuilder func userInput() -> some View {
        
        TextField("", text: $symbol)
            .textFieldStyle(AddSymbolTextFieldStyle(isValid: !symbol.isEmpty ? isSymbolValid : true))
            .focused($inFocus)
        
        Text(isSymbolValid ? "" :  notification)
            .fontWeight(.bold)
            .padding(.top, 20)
    }
    
    @ViewBuilder func bottomBar() -> some View {
        
        Button {
            
            settingsManager.createNewSymbol(symbol)
            presentationMode.wrappedValue.dismiss()
        } label: {
            
            Label(Constants.AddCard.addSymbol, systemImage: "plus.app")
        }
        .buttonStyle(AddCardButtonStyle(isSymbolValid: $isSymbolValid))
        .disabled(!isSymbolValid)
    }
}

// MARK: - Validation functions

private extension AddCardView {
    
    func doesSymbolExist() -> Bool {
        
        return settingsManager.provideSymbols().contains(symbol)
    }
    
    func containsEmoji() -> Bool {
        
        for scalar in symbol.unicodeScalars where scalar.properties.isEmoji {
            
            return true
        }
    
        return false
    }
 
    func validateInput() {
        
        if symbol.isEmpty {
            
            notification = Constants.Notifications.blank
            isSymbolValid = false
            return
        }
        
        if !symbol.isEmpty, symbol.count > 1 {
            
            isSymbolValid = false
            notification = Constants.Notifications.inputTooLong
            return
        }
        
        let containsEmoji = containsEmoji()
        let alreadyExists = doesSymbolExist()
        
        switch containsEmoji {
        case true:
            
            if alreadyExists {
                
                notification = Constants.Notifications.emojiAlreadyExists
                isSymbolValid = false
                return
            }
            
            notification = Constants.Notifications.blank
            isSymbolValid = true
            
        case false:
            
            notification = Constants.Notifications.inputMustContainEmoji
            isSymbolValid = false
        }
    }
}

// MARK: - Constants

private extension AddCardView {
    
    enum Constants {
        
        static let backgroundImage: String = "image-background"
        
        enum AddCard {
            
            static let addSymbol: String = "Add to collection"
            static let title: String = "Add New Emoji"
        }
        
        enum Notifications {
            
            static let inputTooLong: String = "card can contain only one character"
            static let inputMustContainEmoji: String = "card symbol must contain emoji"
            static let emojiAlreadyExists: String = "emoji already exists"
            static let blank: String = ""
        }
    }
}

struct AddCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        AddCardView(settingsManager: SettingsManager())
    }
}
