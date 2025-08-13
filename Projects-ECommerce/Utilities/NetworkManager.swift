//
//  NetworkManager.swift
//  Projects-ECommerce
//
//  Created by Admin on 14/08/25.
//

import Foundation

final class NetworkManager {
    
    static func fetchproducts(_ completionHandler: @escaping ([ProductModel]?, Error?) -> ()) {
        
        let urlString =  EndPoints.fetchProducts.rawValue
        
        //here, I can even separate out the request sending (GET Request), make it generic in a separate function
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error  in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let products =  try decoder.decode([ProductModel].self, from: data)
                        completionHandler(products, nil)
                    } catch {
                        completionHandler(nil, error)
                    }
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        print("API Success")
                        completionHandler(nil, error)
                    } else if response.statusCode == 400 {
                        print("Bad Request")
                        completionHandler(nil, error)
                    }
                }
                if let error = error {
                    print(error.localizedDescription)
                    completionHandler(nil, error)
                }
            }
            task.resume()
        }
    }
    
}

enum EndPoints: String {
    case fetchProducts = "https://fakestoreapi.com/products"
}

//How to create enums for error handling?

//enum NetworkError: String, Error {
//    case unknown = "Unable to fetch results due to some reasons"
//}
