//
//  ProductView.swift
//  Projects-ECommerce
//
//  Created by Admin on 12/08/25.
//

import SwiftUI

//APPROACH - 1
//Can we use product without making it ObservedObject?
//Here we don't see any specific need to observe changes in product.
//as the object itself might not really change, hence using a normal let property

//struct ProductView: View {
//    
//    let product: ProductModel
//    
//    var body: some View {
//        VStack(spacing: 8) {
//            Image(systemName: "xmark")
//                .resizable()
//                .frame(width: 50, height: 50)
//            Text(product.title)
//        }
//        .padding(.all, 8)
//        .background(Color.red)
//    }
//}


//APPROACH - 2
//To observe ProductModel, we would need to make ProductModel a class type instead of a struct
//and mark it as an ObservedObject here
//to see that it functions well, check the code where we are fetching products in HomePageViewModel
//there, I have deliberately made a change in the first product of the list after 3 secs of receiving the response from API
//This change will perfectly reflect in the UI

struct ProductView: View {
    
    @ObservedObject var product: ProductModel
    
    var body: some View {
        VStack(spacing: 8) {
            productImageView
            productInfo
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var productInfo: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(product.title)
                    .lineLimit(1)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "heart")
            }
            Text("Women Joggers")
                .font(.system(size: 12, weight: .light))
                .foregroundColor(Color.gray)
            Text("Rs. 1,241")
                .font(.system(size: 12, weight: .bold)) + Text(" 46% off")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color.orange)
        }
    }
    
    var productImageView: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: product.image ?? "")) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all, 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = phase.error {
                    VStack {
                        Image(systemName: "bag.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        Image(systemName: "circle.dashed")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            ratingsView
        }
        .padding(.all, 8)
        .cornerRadius(8.0)
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .stroke(Color(red: 0.3, green: 0.3, blue: 0.3), lineWidth: 0.3)
        )
        
    }
    
    var ratingsView: some View {
        HStack {
            Text("4")
                .font(.system(size: 10))
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 10, height: 10)
            Text("17")
                .font(.system(size: 10))
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 0.3)
                )
        )
        .padding(.horizontal, 4)
        .padding(.vertical, 3)

    }
}


//#Preview {
//    ProductView()
//}
