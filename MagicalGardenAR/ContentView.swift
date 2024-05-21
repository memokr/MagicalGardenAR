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
    @Environment(SaveScene.self) private var saveScene
    
    @State private var saveAlert = false
    @State private var isOnPlane: Bool = false
    @State private var isOnboardingShowing: Bool = false
    
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        print("Save")
                        self.saveScene.shouldSaveScene = true
                        TappedModelsManager.shared.saveToUserDefaults()
                        saveAlert = true
                    } label: {
                        ZStack{
                            Circle()
                                .fill(Color.black.secondary)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "square.and.arrow.down.fill")
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        isOnboardingShowing = true
                    } label: {
                        ZStack{
                            Circle()
                                .fill(Color.black.secondary)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "info.circle")
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .alert(isPresented: $saveAlert) {
            Alert(title: Text("Successfully Saved Scene"), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            self.saveScene.shouldLoadScene = true
            TappedModelsManager.shared.loadFromUserDefaults()
            if !UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
                isOnboardingShowing = true
            }
        }
        .sheet(isPresented: $isOnboardingShowing, content: {
            OnboardingView(isOnboardingShowing: $isOnboardingShowing)
        })
        
    }
}
