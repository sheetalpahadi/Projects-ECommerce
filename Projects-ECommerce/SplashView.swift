//
//  SplashView.swift
//  Projects-ECommerce
//
//  Created by Admin on 20/08/25.
//

import SwiftUI


//Notes
//Launch screen is static and appears before the application loads
//it is to be mentioned in the project settings
//Splash screen on the other hand, is usually an animation screen that you show, when your data is being prepared to show on the first screen
//for eg - when you are fetching the most imp API data for your home page
//you stop showing splash screen either after a fixed duration or after the data to show on screen is prepared.

//To do:
//1 - Add animations
//2 - Either hardcode time after which splash screen should go away
//3 - or make the splash screen go away once the most relevant API data is fetched

struct SplashView: View {
    
    @State var opacity: CGFloat = 1.0
    
    var body: some View {
        Image("logoWithName")
            .resizable()
            .frame(width: 200, height: 200)
            .opacity(opacity)
            .onAppear {
                let animation = Animation.linear(duration: 1.0).repeatForever(autoreverses: true)
                withAnimation(animation) {
                    opacity = 0.0
                }
            }
    }
}

#Preview {
    SplashView()
}
