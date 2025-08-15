//
//  ProductModelForCSV.swift
//  Projects-ECommerce
//
//  Created by Admin on 14/08/25.
//

import Foundation

class ProductModelForCSV: ObservableObject, Decodable {
    var productID: String
    var productName: String
    var category: String
    var price: String
    var stockQuantity: String
    var description: String
    
    enum CodingKeys: CodingKey {
        case productID
        case productName
        case category
        case price
        case stockQuantity
        case description
    }
    
    init(productID: String, productName: String, category: String, price: String, stockQuantity: String, description: String) {
        self.productID = productID
        self.productName = productName
        self.category = category
        self.price = price
        self.stockQuantity = stockQuantity
        self.description = description
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productID = try container.decodeIfPresent(String.self, forKey: .productID) ?? ""
        self.productName = try container.decodeIfPresent(String.self, forKey: .productName) ?? ""
        self.category = try container.decodeIfPresent(String.self, forKey: .category) ?? ""
        self.price = try container.decodeIfPresent(String.self, forKey: .price) ?? ""
        self.stockQuantity = try container.decodeIfPresent(String.self, forKey: .stockQuantity) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
    }

}
