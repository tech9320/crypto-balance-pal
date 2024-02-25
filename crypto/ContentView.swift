//
//  ContentView.swift
//  crypto
//
//  Created by Tech9320 on 2/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct BitcoinBall: View {


    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                content.add(scene)
            }

        }
    }
}

struct ContentView: View {

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack {
            // Fetch Bitcoin price and show it
            func fetchBitcoinPrice(completion: @escaping (String) -> Void) {
                let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
                URLSession.shared.dataTask(with: url) { (data, _, _) in
                    guard let data = data else {
                        completion("Error: No data")
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
                        let bpi = json["bpi"] as! [String: Any]
                        let usd = bpi["USD"] as! [String: Any]
                        let rate = usd["rate"] as! String
                        completion(rate)
                    } catch {
                        completion("Error: \(error.localizedDescription)")
                    }
                }.resume()
            }

            // Usage:
            fetchBitcoinPrice { rate in
                DispatchQueue.main.async {
                    let bitcoinPriceLabel = Text("Bitcoin price: $\(rate)")
                    // Update UI with the bitcoin price label
                }
            }
                .padding(.top, 50)
                
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, tech9320!")

            // Ovo ce da nam prikaze loptu i da je skloni na ovo dugme/ toggle
                Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                 .toggleStyle(.button)
                .padding(.top, 50)
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                } else {
                    await dismissImmersiveSpace()
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    BitcoinBall()
}
