//
//  crypto_vision_proApp.swift
//  crypto-vision-pro
//
//  Created by Daria Mirkina on 2/24/24.
//

import SwiftUI

@main
struct crypto_vision_proApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
