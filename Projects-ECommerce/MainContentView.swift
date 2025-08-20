//
//  ContentView.swift
//  Projects-ECommerce
//
//  Created by Admin on 12/08/25.
//

import SwiftUI

struct MainContentView: View {
    @State var isSplashViewShown: Bool = true
    var body: some View {
        NavigationView {
            if isSplashViewShown {
                SplashView()
            } else {
                HomePageView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                isSplashViewShown = false
            }
        }
    }
   
}

#Preview {
    MainContentView()
}
