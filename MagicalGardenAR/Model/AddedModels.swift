//
//  AddedModels.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 21/05/24.
//

import Foundation


@Observable
class TappedModelsManager {
    static let shared = TappedModelsManager()
    private init() {}
    
    var addedModels: Set<String> = []
    
    func addModel(_ modelName: String) {
        addedModels.insert(modelName)
    }
    
    func removeModel(_ modelName: String) {
        addedModels.remove(modelName)
    }
    
    func containsModel(_ modelName: String) -> Bool {
        return addedModels.contains(modelName)
    }
    
    func saveToUserDefaults() {
        let modelArray = Array(addedModels)
        UserDefaults.standard.set(modelArray, forKey: "AddedModels")
    }
    
    func loadFromUserDefaults() {
        if let modelArray = UserDefaults.standard.array(forKey: "AddedModels") as? [String] {
            addedModels = Set(modelArray)
        }
    }
}
