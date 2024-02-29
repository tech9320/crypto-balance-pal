//
//  cryptoApp.swift
//  crypto
//
//  Created by Daria Mirkina on 2/24/24.
//

import SwiftUI

@main
struct cryptoApp: App {
    
    @State private var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup("StartingWindow",id: "StartingWindow") {
            ContentView()
                .frame(minWidth: 1000, minHeight: 800)
        }
        .windowResizability(.contentSize)

        WindowGroup(id: "ImmersiveSpace") {
            ImmersiveView(viewModel: viewModel)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1.0, height: 0.8, depth: 0.1, in: .meters)
    }
}
