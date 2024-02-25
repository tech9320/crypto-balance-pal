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
            await fetchBitcoinPrice()
            if let bitcoinPrice = rate {
                Text("Bitcoin Price: \(self.bitcoinPrice, specifier: "%.2f")")
            } else {
                Text("Loading...")
            }
            
            Model3D(named: "Scene", bundle: realityKitContentBundle)
            .rotationEffect(Angle(degrees: rotationAngle))
            .padding(.bottom, 50)
            .onAppear {
                let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                    // Update the rotation angle
                    rotationAngle += 1.0
                }
                // Invalidate the timer when the view disappears
                RunLoop.current.add(timer, forMode: .common)
            }
                .padding(.bottom, 50)

            Text("Hello, tech9320!")

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
        
        func fetchBitcoinPrice() async throws -> Double {
            let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
            let bpi = json["bpi"] as! [String: Any]
            let usd = bpi["USD"] as! [String: Any]
            let rate = usd["rate_float"] as! Double
            self.bitcoinPrice = rate
            return rate
        }
    }
}

#Preview(windowStyle: .automatic) {
    BitcoinBall()
}
