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
        WindowGroup {
            RotationSystem.registerSystem()
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(viewModel: viewModel)
        }
    }
    
}
