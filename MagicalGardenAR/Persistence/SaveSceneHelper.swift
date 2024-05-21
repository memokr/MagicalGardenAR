//
//  SaveSceneHelper.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 21/05/24.
//

import Foundation
import RealityKit
import ARKit

class SaveSceneHelper {
    
    class func saveScene(for arView: CustomARView, at savedUrl: URL){
        print("Save scene to filesystem")
        
        
        //Get current worldMap for arView.session
        
        arView.session.getCurrentWorldMap { worldMap, error in
            
            guard let map = worldMap else {
                print("Error to get the worldMap: \(error!.localizedDescription)")
                return
            }
            
            // Archive data and write to filesystem
            do {
                let sceneData = try NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                
                try sceneData.write(to: savedUrl, options: [.atomic])
            } catch {
                print("Cant save scene to local files \(error.localizedDescription)")
            }
                
        }
    }
    
    class func loadScene(for arView: CustomARView, with loadSceneData: Data){
        print("Load scene from filesystem")
        
        //Unarchive the data and retrieve World Map
        
        let worldMap: ARWorldMap = {
            do {
                guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: loadSceneData) else {
                    fatalError("No ARWorld Map in archive")
                }
                
                return worldMap
            } catch {
                fatalError("Unable to unarchive ARWorld Map from loadSceneData: \(error.localizedDescription)")
            }
            
        }()
        
        // Reset configuration and load WorldMap as initial World Map
        
        let newConfig = arView.defaultConfiguration
        newConfig.initialWorldMap = worldMap
        arView.session.run(newConfig, options: [.resetTracking, .removeExistingAnchors])
    }
    
}

