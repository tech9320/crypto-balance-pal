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

    @State private var ball = Entity()
    @State private var textEntity = Entity()
    
    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            self.ball = try! await Entity(named: "Scene", in: realityKitContentBundle)

                ball.scale = [2, 2, 2]
                ball.position.z = -1.7
                ball.position.y = 1.8
                ball.transform.rotation = simd_quatf(angle: .pi / 4, axis: [0, 1, 0]);
                ball.components.set(InputTargetComponent(allowedInputTypes: .indirect))
                ball.generateCollisionShapes(recursive: false)
                content.add(ball)

                self.textEntity = viewModel.addText(text: "\(String(format: "%.2f", yourBitcoinBalance)) USD" )

                content.add(textEntity)
            }.gesture(
                DragGesture()
                .targetedEntity(ball)
                .onChanged { value in
                    ball.position = value.convert(value.location3D, from: .local, to: ball.parent!)
                    textEntity.position = ball.position + [-0.2, -0.25, 0]
                }
            )
    }
}

#Preview {
    ImmersiveView(viewModel: ViewModel())
        .previewLayout(.sizeThatFits)
}
