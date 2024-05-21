//
//  SwiftUIView.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 20/05/24.
//

import SwiftUI

struct PlacingView: View {
    @Environment(PlacementLogic.self) private var placementLogic
    @Binding var isOnPlane: Bool
    
    
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                PlacingButton(systemIcon: "xmark.circle.fill"){
                    print("Cancel Button Pressed")
                    self.placementLogic.selectedModel = nil
                }
                
                Spacer()
                
                PlacingButton(systemIcon: "checkmark.circle.fill"){
                    print("Confirm Button Pressed")
                    
                    if let selectedModel = self.placementLogic.selectedModel {
                        selectedModel.startTimer()
                        TappedModelsManager.shared.addModel(selectedModel.name)
                        print(selectedModel.name)
                        selectedModel.disableButtons = true 
                    }
                    
                    let modelAnchor = ModelAnchor(model: self.placementLogic.selectedModel!, anchor: nil)
                    self.placementLogic.modelsConfirmedForPlacement.append(modelAnchor)
                    self.placementLogic.selectedModel = nil
                }
                .disabled(isOnPlane ? false : true )
                .opacity(isOnPlane ? 1 : 0)
                .animation(.easeInOut)
                Spacer()
            }
            .padding()
        }
   
    }
}


struct PlacingButton: View {
    let systemIcon: String
    let action: () -> Void
    var body: some View {
        Button{
            self.action()
        } label: {
            Image(systemName: systemIcon)
                .font(.system(size: 50))
                .foregroundStyle(.white)
            
        }
    }
}

//#Preview {
//    PlacingView(isOnPlane: .constant(false))
//        .environment(PlacementLogic())
//}
