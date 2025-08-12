//
//  HomePageView.swift
//  Projects-ECommerce
//
//  Created by Admin on 12/08/25.
//

import SwiftUI

struct HomePageView: View {
    
    @StateObject var viewModel: HomePageViewModel = HomePageViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            headerView
            productsView
            tabBarView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var headerView: some View {
        HStack(spacing: 12) {
            TextField(text: $viewModel.searchText) {
                Text("Type to search products")
            }
        }
        .padding(.all, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var productsView: some View {
        ScrollView {
            VStack(spacing: 8) {
//                ForEach(0 ..< 15, id: \.self) { _ in
//                    ProductView()
//                }
                ForEach(viewModel.products, id: \.id) { product in
                    ProductView(product: product)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity)
    }
    
    var tabBarView: some View {
        HStack(spacing: 4) {
            Text("Home")
                .padding(.all, 4)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
            Text("Fashion")
                .padding(.all, 4)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
            Text("Makeup")
                .padding(.all, 4)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
            Text("Orders")
                .padding(.all, 4)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomePageView()
}
