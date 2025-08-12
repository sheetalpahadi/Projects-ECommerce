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
        self.fetchproducts()
    }
    func fetchproducts() {
        let urlString =  "https://fakestoreapi.com/products"
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error  in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData =  try decoder.decode([ProductModel].self, from: data)
                        //VERY IMPORTANT
                        DispatchQueue.main.async { [weak self] in
                            self?.products = decodedData
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                if let products = self?.products, products.count > 0 {
                                    products[0].title = "Sheetal changed this!"
                                }
                            }
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        print("API Success")
                    } else if response.statusCode == 400 {
                        print("Bad Request")
                    }
                }
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        }
    }
}

// Q.1 - How to capture self weakly inside URLSession.shared.dataTask - DONE
// Q.2. - Understand in-depth the type of values received from a data session closure - data, response, error
// Q.3. - Correct way to write data models - for API response parsing + to be used as data source across views
// Q.4. - Correct way to handle API responses - in-depth
// Q.5. - Ideal way to do error handling - creating enum for common error types within the app (specific to app use-case)
// Q.6. - Modularise code so that a common API manager/NetworkManager is used for API calls
// Q.7. - How to add proper logs to track API calls
// Q.8. -  How to encode our array of products to json
// Q.9. - How to handle cases when a response has certain keys missing? How to write the data model struct to handle such cases without breaking or throwing errors unnecessarily.
