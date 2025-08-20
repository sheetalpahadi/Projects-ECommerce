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
        
        HStack(alignment: .center, spacing: 12) {
            Image("logoWithName")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
            HStack(alignment: .center, spacing: 8) {
                TextField(text: $viewModel.searchText) {
                    Text("Type to search products")
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.black, lineWidth: 0.5)
            )
            HStack {
                Image(systemName: "bell")
                    .frame(width: 20, height: 20)
                    .badge(3)
                Image(systemName: "heart")
                    .frame(width: 20, height: 20)
                Image(systemName: "person")
                    .frame(width: 20, height: 20)
            }
        }
      
        .padding(.all, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var productsView: some View {
        ScrollView {
//            VStack(spacing: 8) {
//                ForEach(viewModel.products, id: \.id) { product in
//                    ProductView(product: product)
//                        .frame(maxWidth: 300)
//                }
//            }
//            .frame(maxWidth: .infinity, alignment: .center)
            let gridItems = [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible()),
            ]
            
            LazyVGrid(columns: gridItems, spacing: 24) {
                ForEach(viewModel.products, id: \.id) { product in
                    ProductView(product: product)
                        .frame(height: 250)
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding()
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
