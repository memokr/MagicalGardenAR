//
//  ContentView.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 19/05/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(PlacementLogic.self) private var placementLogic
    @Environment(Models.self) private var model
    
    @State private var isOnPlane: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ARViewContainer(isOnPlane: $isOnPlane).edgesIgnoringSafeArea(.all)
                
                if self.placementLogic.selectedModel == nil {
                    LayoutView()
                        .environment(model)
                } else {
                    PlacingView(isOnPlane: $isOnPlane)
                }
            }
        }
    }
}
