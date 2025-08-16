//
//  NetworkManager.swift
//  Projects-ECommerce
//
//  Created by Admin on 14/08/25.
//

import Foundation

final class NetworkManager {
    
    
//  1 -  Network Calls without Custom Error Handling
    static func fetchproductsWithoutCustomErrors(_ completionHandler: @escaping ([ProductModel]?, Error?) -> ()) {
        
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
    
    
//    2 - Network Calls with Custom Errros
   static func fetchProductsWithCustomErrors(_ completionHandler: @escaping ([ProductModel], AppError?) -> ()) {
        let urlString = EndPoints.fetchProducts.rawValue
        guard let url = URL(string: urlString) else {
            completionHandler([], AppError.invalidUrl)
            return
        }
        
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode([ProductModel].self, from: data)
                    completionHandler(decodedData, nil)
                } catch {
                    completionHandler([], AppError.invalidResponse)
                }
            } else if let error = error {
                completionHandler([], AppError.unknownServerError)
            } else {
                completionHandler([], AppError.requestTimeOut)
            }
        }
        dataTask.resume()
    }
    
//    3 - Network calls with custom errors handling API errors too
    static func fetchProductsWithApiErrors(_ completionHandler: @escaping ([ProductModel], AppError?) -> ()) {
        let urlString = EndPoints.fetchProducts.rawValue
        guard let url = URL(string: urlString) else {
            completionHandler([], AppError.invalidUrl)
            return
        }
        let request = URLRequest(url: url)
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode([ProductModel].self, from: data)
                    completionHandler(decodedData, nil)
                } catch {
                    completionHandler([], AppError.invalidResponse)
                }
            }
            if let error = error {
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    let errorMessage = error.localizedDescription
                    completionHandler([], AppError.apiError(code: statusCode, errorMessage: errorMessage))
                } else {
                    completionHandler([], AppError.unknownServerError)
                }
            }
        }
        dataTask.resume()
    }
}

enum EndPoints: String {
    case fetchProducts = "https://fakestoreapi.com/products"
}

//Q.1. - How to create enums for error handling? - DONE
//Q.2. - How to use API sent errors and convert them into our errors? - DONE
