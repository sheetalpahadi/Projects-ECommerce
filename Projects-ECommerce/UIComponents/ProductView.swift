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
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 50, height: 50)
            Text(product.title ?? "Product")
        }
        .padding(.all, 8)
        .background(Color.red)
    }
}


//#Preview {
//    ProductView()
//}
