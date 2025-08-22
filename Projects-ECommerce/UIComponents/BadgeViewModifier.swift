//
//  BadgeViewModifier.swift
//  Projects-ECommerce
//
//  Created by Admin on 22/08/25.
//

import Foundation
import SwiftUI

struct BadgeViewModifier: ViewModifier {
    
    var count: Int?
    
    func body(content: Content) -> some View {
        if count != nil {
            content
                .overlay(
                    Text("3")
                        .font(.system(size: 10))
                        .background(
                            Capsule(style: .circular)
                                .fill(Color.red)
                                .frame(minWidth: 14, minHeight: 14)
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .offset(x: 3, y: -3)
                    
                )
        } else {
            content
        }
    }
}

extension View {
    func badgeView(count: Int) -> some View {
        modifier(BadgeViewModifier(count: count))
    }
}
