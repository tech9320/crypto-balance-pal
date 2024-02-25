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
                .padding(.bottom, 50)

            Text("Hello, tech9320!")

            TextField("Enter Bitcoin Amount", text: $enteredBitcoinAmount)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .padding(.top, 50)
            
            Text("Entered Bitcoin Amount: \(enteredBitcoinAmount)")
                .padding(.top, 50)

            Text("Bitcoin value: \(self.rate) USD")
                .padding(.top, 50)
            // Ovo ce da nam prikaze loptu i da je skloni na ovo dugme/ toggle
                Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                 .toggleStyle(.button)
                .padding(.top, 50)

            Text("Your Bitcoin Balance is : \(yourBitcoinBalance, specifier: "%.2f") USD")
                .padding(.top, 50)
                .font(.title)
                .foregroundColor(.green)
                .accessibility(identifier: "YourBitcoinBalanceLabel")
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                    fetchBitcoinPrice()
                    calculateYourBitcoinBalance()
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
            }
        }
        task.resume()

    }
    func calculateYourBitcoinBalance(){
        if let bitcoinAmount = Double(enteredBitcoinAmount){
            yourBitcoinBalance = bitcoinAmount * Double(rate)!
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
