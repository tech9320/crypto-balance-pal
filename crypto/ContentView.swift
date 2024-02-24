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

    
@IBAction func rotateView(sender: UIButton) {
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: { () -> Void in
        self.spinningView.transform = self.spinningView.transform.rotated(by: .pi / 2)
    }) { (finished) -> Void in
        self.rotateView(sender: sender)
    }
}

     var body: some View {
        RealityView { content in
            if let scene = try? await Entity.load(named: "Scene") {
                // Add the loaded scene to the content
                content.add(scene)
                
                // Start spinning the entity
                rotateView(entity: scene)
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
            Model3D(named: "Scene", bundle: realityKitContentBundle)
                .padding(.bottom, 50)

            Text("Hello, tech9320!")

            // I dalje mi je nejasno sta ce nam ovo tacno
            Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
                .padding(.top, 50)
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    BitcoinBall()
}
