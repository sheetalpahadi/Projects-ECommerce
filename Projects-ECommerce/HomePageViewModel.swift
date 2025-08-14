//
//  HomePageViewModel.swift
//  Projects-ECommerce
//
//  Created by Admin on 12/08/25.
//

import Foundation
import SwiftUI

class HomePageViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var products: [ProductModel] = []
    
    init() {
//        self.fetchproducts()
//        fetchproductsFromLocalFileSync()
        fetchproductsFromLocalFileAsync()
    }
    
    
//    Approach 2 - Separating to a network layer
    func fetchproducts() {
        NetworkManager.fetchproducts { products, error in
            if let products = products {
                DispatchQueue.main.async { [weak self] in
                    self?.products = products
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        if let products = self?.products, products.count > 0 {
                            self?.products[0].title = "Sheetal changed this!"
                        }
                    }
                }
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
//    Approach 1 -  not separating a network layer
//    func fetchproducts() {
//        let urlString =  "https://fakestoreapi.com/products"
//        if let url = URL(string: urlString) {
//            let request = URLRequest(url: url)
//            let task = URLSession.shared.dataTask(with: request) { data, response, error  in
//                if let data = data {
//                    let decoder = JSONDecoder()
//                    do {
//                        let decodedData =  try decoder.decode([ProductModel].self, from: data)
//                        //VERY IMPORTANT
//                        DispatchQueue.main.async { [weak self] in
//                            self?.products = decodedData
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                                if let products = self?.products, products.count > 0 {
//                                    products[0].title = "Sheetal changed this!"
//                                }
//                            }
//                        }
//                        
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//                if let response = response as? HTTPURLResponse {
//                    if response.statusCode == 200 {
//                        print("API Success")
//                    } else if response.statusCode == 400 {
//                        print("Bad Request")
//                    }
//                }
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//            }
//            task.resume()
//        }
//    }
    
    
//    Loading JSON from a local file - using synchronous fetching
    func fetchproductsFromLocalFileSync() {
        if let url = Bundle.main.url(forResource: "DummyProducts", withExtension: "json") {
            do {
                let fetchedData = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([ProductModel].self, from: fetchedData)
                print("data fetched synchronously from local json")
                self.products = decodedData
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
//    Loading JSON from a local file - using asynchronous fetching
    func fetchproductsFromLocalFileAsync() {
        if let url = Bundle.main.url(forResource: "DummyProducts", withExtension: "json") {
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode([ProductModel].self, from: data)
                        DispatchQueue.main.async { [weak self] in
                            print("data fetched asynchronously from local json")
                            self?.products = decodedData
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            dataTask.resume()
        }
    }
}

// Q.1 - How to capture self weakly inside URLSession.shared.dataTask - DONE
// Q.2. - Understand in-depth the type of values received from a data session closure - data, response, error
// Q.3. - Correct way to write data models - for API response parsing + to be used as data source across views - DONE
// Q.4. - Correct way to handle API responses - in-depth 
// Q.5. - Ideal way to do error handling - creating enum for common error types within the app (specific to app use-case)
// Q.6. - Modularise code so that a common API manager/NetworkManager is used for API calls
// Q.7. - How to add proper logs to track API calls
// Q.8. -  How to encode our array of products to json
// Q.9. - How to handle cases when a response has certain keys missing? How to write the data model struct to handle such cases without breaking or throwing errors unnecessarily.
