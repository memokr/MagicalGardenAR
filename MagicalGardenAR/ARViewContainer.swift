//
//  ARViewContainer.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 20/05/24.
//

import SwiftUI
import RealityKit
import ARKit

private let anchorNamePrefix = "model-"

struct ARViewContainer: UIViewRepresentable {
    
    @Environment(PlacementLogic.self) private var placementLogic
    @Environment(Models.self) private var model
    @Environment(SaveScene.self) private var savedScene
    
    @Binding var isOnPlane: Bool
    
    @State private var hasPlayedAudio = false
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        arView.session.delegate = context.coordinator
        
        arView.isUserInteractionEnabled = true
        
        context.coordinator.arView = arView
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTapPress(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        self.placementLogic.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            self.updateScene(for: arView)
            self.handleSave(for: arView)
        })
        
        // Adding the coaching overlay on the AR View
        arView.addCoaching()

        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {
    }
    
    private func updateScene(for arView: CustomARView) {
        // Show Focus Entity just when the user chooses a plant for placement
        arView.focusEntity?.isEnabled = self.placementLogic.selectedModel != nil
        if let onPlane = arView.focusEntity?.onPlane {
            isOnPlane = onPlane
        }

        addModelToScene(arView: arView)
        
        for plant in model.plants {
            plant.onTimerEnd = {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.handleTimerEnd(for: plant, in: arView)
                }
            }
            
            if TappedEntitiesManager.shared.tappedEntities.count == 3 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    plant.currentAnimation?.resume()
                    if !self.hasPlayedAudio {
                        self.playAudio(on: arView, sound: "Music", type: "wav")
                        self.hasPlayedAudio = true
                    }
                }
            }
        }
        
        
    }
    
    private func addModelToScene(arView: CustomARView){
        if let modelAnchor = self.placementLogic.modelsConfirmedForPlacement.popLast(), let modelEntity = modelAnchor.model.modelEntity {
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.name = modelAnchor.model.name
            
            
            if let anchor = modelAnchor.anchor {
                // Anchor is being loaded for persistence scene
                self.place(modelEntity, for: anchor, in: arView)
            } else if let transform = getTransformForPlacement(in: arView) {
                let anchorName = anchorNamePrefix + modelAnchor.model.name
                let anchor = ARAnchor(name: anchorName, transform: transform)
                self.place(modelEntity, for: anchor, in: arView)
                arView.session.add(anchor: anchor)
            }
        }
    }
    private func place(_ entity: Entity, for anchor: ARAnchor, in arView: ARView) {
        // Create an anchor entity
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(entity)
        
        // Add the anchor entity to the scene
        arView.scene.addAnchor(anchorEntity)
        
        self.savedScene.anchorEntities.append(anchorEntity)
        
        print("Added entity to the scene \(entity.name)")
    }
    
    private func getTransformForPlacement(in arView: ARView) -> simd_float4x4? {
        guard let query = arView.makeRaycastQuery(from: arView.center, allowing: .estimatedPlane, alignment: .any) else {
            return nil
        }
        guard let rayCastResult = arView.session.raycast(query).first else {
            return nil
        }
        
        return rayCastResult.worldTransform
    }
    private func handleTimerEnd(for plant: PlantModel, in arView: CustomARView) {
        print("Timer ended, triggering animation for \(plant.name)")  // Debug print
        

        guard let entity = arView.scene.findEntity(named: plant.name) else {
            print("Entity \(plant.name) not found in scene")  // Debug print
            return
        }
        
        guard let triggerCall = plant.triggerAnimation else {return}
        
        if triggerCall{
            guard let audioFileURL = Bundle.main.url(forResource: "SFX_2", withExtension: "wav") else {
                print("Audio file not found")
                return
            }
            
            let audioResource = try! AudioFileResource.load(contentsOf: audioFileURL, withName: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: triggerCall)
            
            let audioPlaybackController = entity.playAudio(audioResource)
            plant.currentlyPlayingAudio = audioPlaybackController
            print("Playing call for \(plant.name)")
        }
        
    }
    private func playAudio(on arView: ARView, sound: String, type: String) {
           guard let audioFileURL = Bundle.main.url(forResource: sound, withExtension: type) else {
               print("Audio file not found")
               return
           }
           
           let audioResource = try! AudioFileResource.load(contentsOf: audioFileURL, withName: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
           
           // Play audio on a specific entity or create an audio anchor
           let audioAnchor = AnchorEntity(world: [0, 0, 0])
           arView.scene.addAnchor(audioAnchor)
           
           audioAnchor.playAudio(audioResource)
       }
}


extension ARViewContainer {
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        var arView: CustomARView?
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        @objc func handleTapPress(_ recognizer: UITapGestureRecognizer) {
            guard let view = self.arView else { return }
            let tapLocation = recognizer.location(in: view)
            
            if var entity = view.entity(at: tapLocation){
                while let parent = entity.parent, !(parent is AnchorEntity) {
                    entity = parent
                }
                print("Entity tapped \(entity.name)")
                if let plantModel = self.parent.model.plants.first(where: { $0.name == entity.name }) {
                    guard let animated = plantModel.triggerAnimation else { return }
                    if animated{
                        playGrowAnimation(entity: entity, plantModel: plantModel)
                    }
                }
            }
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            for anchor in anchors {
                if let anchorName = anchor.name, anchorName.hasPrefix(anchorNamePrefix) {
                    let modelName = anchorName.dropFirst(anchorNamePrefix.count)
                    print("ARSession: didAdd anchor for modelName: \(modelName)")
                    
                    guard let model = self.parent.model.plants.first(where: { $0.name == modelName }) else {
                        print("Unable to retrieve model from PlantModel \(modelName)")
                        return
                    }
                    
                    if model.modelEntity == nil {
                        Task {
                            let (completed, error) = await model.asyncLoadModelEntity()
                            if completed {
                                let modelAnchor = ModelAnchor(model: model, anchor: anchor)
                                self.parent.placementLogic.modelsConfirmedForPlacement.append(modelAnchor)
                                print("Adding Model Anchor with name \(model.name)")
                            } else {
                                if let error = error {
                                    print("Failed to load model for \(model.name): \(error.localizedDescription)")
                                } else {
                                    print("Unknown error occurred while loading model for \(model.name)")
                                }
                            }
                        }
                    }
                }
            }
        }
        
        func playGrowAnimation(entity: Entity, plantModel: PlantModel){
            plantModel.currentlyPlayingAudio?.stop()
            guard let audioFileURL = Bundle.main.url(forResource: plantModel.sound, withExtension: "wav") else {
                print("Audio file not found")
                return
            }

            do {
                let audioResource = try AudioFileResource.load(contentsOf: audioFileURL, withName: nil, inputMode: .spatial, loadingStrategy: .preload, shouldLoop: false)
                entity.playAudio(audioResource)
            } catch {
                print("Failed to load audio resource: \(error)")
                return
            }
            
            if !entity.availableAnimations.isEmpty {
                let animationPlaybackController = entity.playAnimation(entity.availableAnimations[0])
                plantModel.currentAnimation = animationPlaybackController
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                    if let pause = plantModel.currentAnimation{
                        pause.pause()
                    }
                }
            }
            
            TappedEntitiesManager.shared.tappedEntities.insert(plantModel.name)
            plantModel.triggerAnimation = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
}


extension ARViewContainer {
    private func updateAvailability(for arView: ARView) {
        guard let currentFrame = arView.session.currentFrame else {
            print("ARFrame not available")
            return
        }
        
        switch currentFrame.worldMappingStatus {
        case .extending, .mapped:
            self.savedScene.isSceneSaved = !self.savedScene.anchorEntities.isEmpty
        default:
            self.savedScene.isSceneSaved = false
        }
    }
    
    private func handleSave(for arView: CustomARView) {
        if self.savedScene.shouldSaveScene {
            SaveSceneHelper.saveScene(for: arView, at: self.savedScene.savedUrl)
            self.savedScene.shouldSaveScene = false
        } else if self.savedScene.shouldLoadScene {
            guard let sceneData = self.savedScene.loadSceneData else {
                print("Unable to retrieve scenePersistenceData. Canceled loadScene operation")
                self.savedScene.shouldLoadScene = false
                return
            }
            
            SaveSceneHelper.loadScene(for: arView, with: sceneData)
            self.savedScene.anchorEntities.removeAll(keepingCapacity: true)
            self.model.clearModelEntitiesFromMemory()
            self.savedScene.shouldLoadScene = false
        }
    }
}
