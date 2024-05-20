//
//  PlacementLogic.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 20/05/24.
//

import SwiftUI
import RealityKit
import Combine
import ARKit

struct ModelAnchor{
    var model: PlantModel
    var anchor: ARAnchor?
    var triggerGrow: Bool?
}

@Observable
class PlacementLogic {
    var selectedModel: PlantModel? {
        willSet(newValue){
            print("selectedModel to \(String(describing: newValue?.name))")
        }
    }
    
    // This property will keep track of all the content that has been confirme for placement in the scene.
    var modelsConfirmedForPlacement: [ModelAnchor] = []
    
    var sceneObserver: Cancellable?
}
