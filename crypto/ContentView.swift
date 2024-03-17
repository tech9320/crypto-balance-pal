//
//  ContentView.swift
//  crypto
//
//  Created by Tech9320 on 2/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Binding var bitcoinBalance: String
    @Binding var bitcoinValue: String
    @Binding var enteredBitcoinAmount: String
    var fetchBitcoinPrice: () -> Void
    var calculateYourBitcoinBalance: () -> Void

    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        
        HStack {
            
            VStack {
                Image(.logo)
                    .resizable()
                    .frame(width: 350, height: 350)
                    .padding(.bottom, 20)
                
                Text("CryptoBalance Pal - Your Virtual Crypto Companion")

                Text("Welcome to CryptoBalance Pal, your one-stop solution for tracking your Bitcoin holdings in an immersive experience. Seamlessly manage your cryptocurrency portfolio with a user-friendly interface designed for the Apple Vision Pro.")
                    .padding(.horizontal, 80)
                    .padding(.top, 20)
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .onAppear() {
                dismissWindow(id: "ImmersiveSpace")
                fetchBitcoinPrice()
            }
            
            
            VStack {
                
                Text("Current Bitcoin Value:")
                Text("\(self.bitcoinValue) USD")
                    
                TextField("Enter Your Bitcoin Amount", text: $enteredBitcoinAmount)
                    .keyboardType(.decimalPad)
                    .frame(width: 250)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 20)
                    .onChange(of: enteredBitcoinAmount) {
                        calculateYourBitcoinBalance()
                    }
                
           
                Text("Your holdings in USD: \(bitcoinBalance) USD")
                    .padding(.top, 20)
                
                Button("Proceed") {
                    calculateYourBitcoinBalance()
                    openWindow(id: "ImmersiveSpace")
                }

            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            
        }
        

    }
}

#Preview(windowStyle: .automatic) {
    let bitcoinBalance = Binding.constant("0.0")
    let bitcoinValue = Binding.constant("0.0")
    let enteredBitcoinAmount = Binding.constant("")

    return ContentView(bitcoinBalance: bitcoinBalance,
                       bitcoinValue: bitcoinValue,
                       enteredBitcoinAmount: enteredBitcoinAmount,
                       fetchBitcoinPrice: {},
                       calculateYourBitcoinBalance: {})
}
