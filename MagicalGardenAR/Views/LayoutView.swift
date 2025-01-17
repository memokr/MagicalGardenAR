//
//  LayoutView.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 20/05/24.
//

import SwiftUI

struct LayoutView: View {
    
    @Environment(PlacementLogic.self) private var placementLogic
    @Environment(Models.self) private var model
    
//    @State private var disableButtons: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 50) {
                ForEach(model.plants.indices, id: \.self) { index in
                    let model = model.plants[index]
                    
                    ZStack {
                        VStack{
                            Button {
                                Task {
                                    let (completed, error) = await model.asyncLoadModelEntity()
                                    if completed {
                                        self.placementLogic.selectedModel = model
                                    } else {
                                        if let error = error {
                                            print("Failed to load model for \(model.name): \(error.localizedDescription)")
                                        } else {
                                            print("Unknown error occurred while loading model for \(model.name)")
                                        }
                                    }
                                }
                            } label: {
                                ZStack{
                                    CircularProgressView(remainingSeconds: model.remainingTime, totalDuration: model.totalDuration)
                                        .frame(width: 79)
                                    Image(model.placeholder)
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                        .frame(width: 70)
                                        .shadow(radius: 10)
                                        .opacity(model.disableButtons ? 0.5 : 1.0)
                                }
                            }
                            .disabled(model.disableButtons)
                        }
                    }.onAppear{
                        if TappedModelsManager.shared.containsModel(model.name) {
                            model.disableButtons = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LayoutView()
        .environment(PlacementLogic())
        .environment(Models())
}
