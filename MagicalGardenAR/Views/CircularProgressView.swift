//
//  CircularProgressView.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 20/05/24.
//

import SwiftUI

struct CircularProgressView: View {
    @State var remainingSeconds: Int
    @State var totalDuration: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.secondary.opacity(0.5),
                    lineWidth: 10
                )
            
            Circle()
                .trim(from: 0, to: calculateProgress())
                .stroke(
                    Color.green,
                    style: StrokeStyle(
                        lineWidth: 10,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: calculateProgress())

        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            }
        }
    }
    func calculateProgress() -> Double {
          guard remainingSeconds > 0 else { return 0 }
          return 1 - Double(remainingSeconds) / Double(totalDuration)
    }
}



//#Preview {
//    CircularProgressView(remainingSeconds: 100, totalDuration: 100)
//}
