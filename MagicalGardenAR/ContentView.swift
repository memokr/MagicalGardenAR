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
    @State private var showAlert = false
    
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
                ToolbarItem(placement: .topBarLeading) {
                    Button{
                        showAlert = true
                    } label: {
                        ZStack{
                            Circle()
                                .fill(Color.black.secondary)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "arrow.circlepath")
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .alert("Successfully Saved Garden", isPresented: $saveAlert) {
                      Button("OK", role: .cancel) { }
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Reset Garden"),
                    message: Text("Are you sure you want to reset your Garden?"),
                    primaryButton: .destructive(Text("Reset")) {
                        reset()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    func reset(){
        for anchorEntity in self.saveScene.anchorEntities {
            anchorEntity.removeFromParent()
        }
        for plant in model.plants {
            plant.reset()
        }
        TappedModelsManager.shared.reset()
        saveScene.reset()
        SaveSceneHelper.clearSavedScene(at: saveScene.savedUrl) 
    }
}
