//
//  CustomARView.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 20/05/24.
//

import RealityKit
import ARKit
import FocusEntity


class CustomARView: ARView{
    
    var focusEntity: FocusEntity?
    
    var defaultConfiguration: ARWorldTrackingConfiguration {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]

        
        return configuration
        
    }
    
    required init(frame frameRect: CGRect){
        super.init(frame: frameRect)
        
        focusEntity = FocusEntity(on: self, focus: .classic)
        
        
        configuration()
    }
    
    @objc required dynamic init?(coder decoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration(){
        session.run(defaultConfiguration)
    }
}

extension CustomARView: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()

        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        self.addSubview(coachingOverlay)
    }
}


