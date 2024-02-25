import RealityKit
import Observation

@Observable
class ViewModel {

    func addText(text: String) -> Entity {

        let textMeshResource: MeshResource = .generateText(text,
                                                           extrusionDepth: 0.05,
                                                           font: .systemFont(ofSize: 0.1),
                                                           containerFrame: .zero,
                                                           alignment: .center,
                                                           lineBreakMode: .byWordWrapping)

        let material = UnlitMaterial(color: .white)

        let textEntity = ModelEntity(mesh: textMeshResource, materials: [material])
        textEntity.position = SIMD3(x: -(textMeshResource.bounds.extents.x / 2), y: 1.55, z: -1.7)

        return textEntity
    }
}
