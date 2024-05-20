//
//  TappedEntities.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 20/05/24.
//

import Foundation

class TappedEntitiesManager {
    static let shared = TappedEntitiesManager()
    private init() {}

    var tappedEntities: Set<String> = []
}
