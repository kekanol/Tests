//
//  Animation.swift
//  Test
//
//  Created by Константин on 23.04.2021.
//

import SwiftUI

struct AnimationView: View {
    @State private var isAnimating: Bool = false
    var showProgress: Bool
    var foreverAnimation: Animation {
        Animation.linear(duration: 1.0)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        
        if showProgress {
            Image(systemName: "arrow.2.circlepath")
                .resizable()
                
                .rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
                .animation(self.isAnimating ? foreverAnimation : .default)
                .onAppear { self.isAnimating = true }
                .onDisappear { self.isAnimating = false }
        } else {
            Image(systemName: "arrow.2.circlepath")
                .resizable()
        }
    }
}

struct Animation_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView(showProgress: true)
    }
}
