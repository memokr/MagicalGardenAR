//
//  PlantModel.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 20/05/24.
//



import SwiftUI
import RealityKit
import Combine

@Observable
class PlantModel {
    var name: String
    var placeholder: String
    var modelEntity: Entity?
    var triggerAnimation: Bool?
    var sound: String
    var currentlyPlayingAudio: AudioPlaybackController?
    var currentAnimation: AnimationPlaybackController?
    var disableButtons: Bool = false
    var callingSound: String
    var totalDuration: Int {
         didSet {
             UserDefaults.standard.set(totalDuration, forKey: "TotalDuration_\(name)")
         }
     }
    
    var remainingTime: Int {
        didSet {
            UserDefaults.standard.set(remainingTime, forKey: "RemainingTime_\(name)")
        }
    }
    var isTimerRunning: Bool = false
    
    private var timer: Timer?

    
    var onTimerEnd: (() -> Void)?
    
    
    init(name: String, placeholder: String, sound: String, callingSound: String) {
        self.name = name
        self.placeholder = placeholder
        self.sound = sound
        self.callingSound = callingSound
        
        let savedStartTime = UserDefaults.standard.double(forKey: "StartTime_\(name)")
        let savedDuration = UserDefaults.standard.integer(forKey: "Duration_\(name)")
        self.totalDuration = UserDefaults.standard.integer(forKey: "TotalDuration_\(name)")
           
        if savedStartTime > 0 && savedDuration > 0 {
            let elapsedTime = Int(Date().timeIntervalSince1970) - Int(savedStartTime)
            self.remainingTime = max(savedDuration - elapsedTime, 0)
            if self.remainingTime > 0 {
                self.startTimer()
            }
        } else {
            self.remainingTime = 0
        }
    }
    
    private var cancellable: AnyCancellable?
    
    func asyncLoadModelEntity() async -> (Bool, Error?) {
        let filename = self.name + ".usdz"
        
        
        do {
            let entity = try await Entity.load(named: filename)
                self.modelEntity = entity
                print("modelEntity for \(self.name) has been loaded")
                return (true, nil)
            
        } catch {
            print("Unable to load modelEntity for \(filename). Error \(error.localizedDescription)")
            return (false, error)
        }
    }
    
    func startTimer() {
         // Invalidate existing timer if any
         timer?.invalidate()
         
         if remainingTime == 0 {
             remainingTime = Int.random(in: 30...180)
             totalDuration = remainingTime
         }
         
        print("Timer start with \(remainingTime)")
        isTimerRunning = true
    
         
         // Save start time and duration to UserDefaults
         let startTime = Date().timeIntervalSince1970
         UserDefaults.standard.set(startTime, forKey: "StartTime_\(name)")
         UserDefaults.standard.set(remainingTime, forKey: "Duration_\(name)")
         
         timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
             guard let self = self else { return }
             self.remainingTime -= 1
             if self.remainingTime == 0 {
                 self.stopTimer()
                 print("Timer ended for \(self.name)")
                 self.triggerAnimation = true
                 DispatchQueue.main.async {
                     self.onTimerEnd?()
                 }
             }
         }
     }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        // Clear saved start time and duration
        UserDefaults.standard.removeObject(forKey: "StartTime_\(name)")
        UserDefaults.standard.removeObject(forKey: "Duration_\(name)")
        
        isTimerRunning = false
        totalDuration = -1 
    }
    
    func reset() {
           // Invalidate and clear the timer
           timer?.invalidate()
           timer = nil
           
           // Clear UserDefaults entries
           UserDefaults.standard.removeObject(forKey: "StartTime_\(name)")
           UserDefaults.standard.removeObject(forKey: "Duration_\(name)")
           UserDefaults.standard.removeObject(forKey: "TotalDuration_\(name)")
           UserDefaults.standard.removeObject(forKey: "RemainingTime_\(name)")
           
           // Reset properties to initial values
           modelEntity = nil
           triggerAnimation = nil
           currentlyPlayingAudio = nil
           currentAnimation = nil
           disableButtons = false
           totalDuration = 0
           remainingTime = 0
           isTimerRunning = false
       }
}


