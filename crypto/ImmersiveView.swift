//
//  ImmersiveView.swift
//  crypto
//
//  Created by Tech9320 on 2/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    var viewModel: ViewModel
    var contentView: ContentView
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let ball = try? await Entity(named: "Scene", in: realityKitContentBundle) {
                contentView.fetchBitcoinPrice()
                ball.scale = [2, 2, 2]
                ball.position.z = -1.7
                ball.position.y = 1.8
                ball.transform.rotation = simd_quatf(angle: .pi / 4, axis: [0, 1, 0]);
                content.add(ball)
                let textEntity = viewModel.addText(text: contentView.returnRate())
                content.add(textEntity)
            }
        }
    }
}

#Preview {
    ImmersiveView(viewModel: ViewModel(), contentView: ContentView())
        .previewLayout(.sizeThatFits)
}
