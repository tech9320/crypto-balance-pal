//
//  ContentView.swift
//  crypto
//
//  Created by Tech9320 on 2/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

public var yourBitcoinBalance = 0.0
public var kolkoSamUneo = ""

struct ContentView: View {

    @State private var rate = "Loading..."
    @State private var enteredBitcoinAmount = kolkoSamUneo
    
    // Created a copy of the public variable because rerenders are only triggered for State variables
    @State private var privateBitcoinBalance = 0.0

    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        
        HStack {
            
            VStack {
                // Logo Placeholder
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
                Text("\(self.rate) USD")
                    
                TextField("Enter Your Bitcoin Amount", text: $enteredBitcoinAmount)
                    .keyboardType(.decimalPad)
                    .frame(width: 250)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 20)
                    .onChange(of: enteredBitcoinAmount) {
                        kolkoSamUneo = enteredBitcoinAmount
                        calculateYourBitcoinBalance()
                    }
                
           
                Text("Your holdings in USD: \(privateBitcoinBalance, specifier: "%.2f") USD")
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
    
    func fetchBitcoinPrice(){
        print("Fetching Bitcoin Price")
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let bpi = json["bpi"] as! [String: Any]
                let usd = bpi["USD"] as! [String: Any]
                let rate = usd["rate"] as! String
                self.rate = rate
                print("Bitcoin price: \(rate)")
                calculateYourBitcoinBalance()
            }
        }
        task.resume()

    }
    
    func calculateYourBitcoinBalance(){
        print("Calculating your Bitcoin Balance: \(enteredBitcoinAmount)")
        if let bitcoinAmount = Double(enteredBitcoinAmount) {
            if let bitcoinRate = Double(rate.replacingOccurrences(of: ",", with: "")) {
                yourBitcoinBalance = bitcoinAmount * bitcoinRate
                privateBitcoinBalance = bitcoinAmount * bitcoinRate
            }
        } else {
            yourBitcoinBalance = 0.0
            privateBitcoinBalance = 0.0
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
