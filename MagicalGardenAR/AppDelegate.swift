//
//  AppDelegate.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 19/05/24.
//

import UIKit
import SwiftUI


@main
struct AppDelegate: App {
    @State private var placementLogic = PlacementLogic()
    @State private var model = Models()
    @State private var savedScene = SaveScene()
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(placementLogic)
                .environment(model)
                .environment(savedScene)
        }
    }
}


