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
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        VStack {
                
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, tech9320!")

            Text("Bitcoin price: \(self.rate)")
                .padding(.top, 50)
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
            }
        }
        task.resume()

    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
