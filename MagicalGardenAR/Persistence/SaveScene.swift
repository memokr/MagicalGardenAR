//
//  SaveScene.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 21/05/24.
//

import SwiftUI
import RealityKit
import ARKit

@Observable
class SaveScene {
    var isSceneSaved: Bool = false
    var anchorEntities: [AnchorEntity] = []
    
    var shouldSaveScene: Bool = false
    var shouldLoadScene: Bool = false
    
    var savedUrl: URL = {
        do {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("arf.saved")
        } catch {
            fatalError("Unable to get savedUrl: \(error.localizedDescription)")
        }
    }()
    
    var loadSceneData: Data? {
        return try? Data(contentsOf: savedUrl)
    }
}
