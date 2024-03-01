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
    
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow

    var viewModel: ViewModel

    @State private var ball = Entity()
    
    var body: some View {
        RealityView { content in
            dismissWindow(id: "StartingWindow")
            self.ball = try! await Entity(named: "Scene", in: realityKitContentBundle)
            ball.scale = [2, 2, 2]
            ball.transform.rotation = simd_quatf(angle: .pi / 4, axis: [0, 1, 0]);
            content.add(ball)
            let textEntity = viewModel.addText(text: "\(String(format: "%.2f", yourBitcoinBalance)) USD" )
            content.add(textEntity)
        }
        
        Button("Close") {
            openWindow(id: "StartingWindow")
            dismissWindow(id: "ImmersiveSpace")
        }
        .frame(width: 100, height: 50)
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(10)
        Button("Refresh") {
            fetchBitcoinPrice()
        }
        .frame(width: 100, height: 50)
        .foregroundColor(.white)
        .cornerRadius(10)
        
    }
}

#Preview {
    ImmersiveView(viewModel: ViewModel())
        .previewLayout(.sizeThatFits)
}
