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
    @State private var contentView = ContentView()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(viewModel: viewModel, contentView: contentView)
        }
    }
}
