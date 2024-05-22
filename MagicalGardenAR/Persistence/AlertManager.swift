//
//  AlertManager.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 22/05/24.
//

import Foundation

import Combine

class AlertManager: ObservableObject {
    static let shared = AlertManager()
    
    @Published var showAlert = false
    @Published var errorMessage = ""

    private init() {}
    
    func triggerAlert(with message: String) {
        errorMessage = message
        showAlert = true
    }
}


