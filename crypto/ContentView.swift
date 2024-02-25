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

    @State private var rate = "Loading..."
    @State private var enteredBitcoinAmount = ""
    @State public var yourBitcoinBalance = 0.0
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack {
                
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 20)

            Text("Hello, tech9320!")

            TextField("Enter Bitcoin Amount", text: $enteredBitcoinAmount)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .padding(.top, 20)
            
            Text("Entered Bitcoin Amount: \(enteredBitcoinAmount)")

            Text("Bitcoin value: \(self.rate) USD")
            // Ovo ce da nam prikaze loptu i da je skloni na ovo dugme/ toggle
                Toggle("Calculate", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
                .padding(.top, 20)

            Text("Your Bitcoin Balance is : \(yourBitcoinBalance, specifier: "%.2f") USD")
                .padding(.top, 20)
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                    fetchBitcoinPrice()
                } else {
                    await dismissImmersiveSpace()
                }
            }
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
        print("Calculating your Bitcoin Balance")
        if let bitcoinAmount = Double(enteredBitcoinAmount) {
            if let bitcoinRate = Double(rate.replacingOccurrences(of: ",", with: "")) {
                yourBitcoinBalance = bitcoinAmount * bitcoinRate
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
