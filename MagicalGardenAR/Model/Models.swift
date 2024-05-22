//
//  Models.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 20/05/24.
//

import Foundation

@Observable
class Models {
    var plants: [PlantModel] = []
    
    init() {
        
        // Growing Plants
        let growOne = PlantModel(name: "Plant_01_Growth+Bloom", placeholder: "Plant01", sound: "SFX_4", callingSound: "SFX_2" )
        let growTwo = PlantModel(name: "Plant_02_Growth+Bloom", placeholder: "Plant02", sound: "SFX_5", callingSound: "SFX_3")
        let growThree = PlantModel(name: "Plant_03_Growth+Bloom", placeholder: "Plant03", sound: "SFX_7", callingSound: "SFX_6")
        
        self.plants += [growOne,growTwo,growThree]
    }
    
    func clearModelEntitiesFromMemory(){
        for plant in plants {
            plant.modelEntity = nil
        }
    }
}

