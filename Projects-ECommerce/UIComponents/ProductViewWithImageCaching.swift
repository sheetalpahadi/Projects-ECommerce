//
//  ProductViewWithImageCaching.swift
//  Projects-ECommerce
//
//  Created by Admin on 24/08/25.
//


// Caching concerns for home page:
// 1 - When the user scrolls up and down, already loaded image shouldn't load again :Done
// 2 - Downnsample product images for fast loading (but, what if you want to open the image in some other screen wwith full resolution?)
// 3 - For data that is important for rendering the main home page (right after app launch), response should be prefetched?
//    Q. Should images for the home screen be prefetched too?
//          -> Ideally yes for absolute first screen, for other screens, depends on different factors.


import SwiftUI

struct ProductViewWithImageCaching: View {
    
    @ObservedObject var product: ProductModel
    
    @State var image: Image?
    
    var body: some View {
        VStack(spacing: 8) {
            productImageView
            productInfo
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            //Faster image loading happening due to 2 reasons
            //1- prefetching image data from image url on onAppear, before view appears
            //2- Loading it from cache
            DispatchQueue.global().async {
                ImageCacheManager.shared.getImage(for: product.image ?? "") { fetchedImage in
                    DispatchQueue.main.async {
                        image = fetchedImage
                    }
                }
            }
        }
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
            image?
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.all, 8)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
//    ProductViewWithImageCaching()
//}



//Questions
//1. Why is [weak self] not needed in onAppear() ?
