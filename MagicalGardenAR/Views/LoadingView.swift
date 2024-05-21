//
//  LoadingView.swift
//  MagicalGardenAR
//
//  Created by Guillermo Kramsky on 21/05/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
                .padding()
        }
    }
}


#Preview {
    LoadingView()
}
