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
//        fetchproductsWithoutNetworkLayer()
//        fetchProductsWithCustomError()
//        fetchProductsWithApiErrors()
//        fetchproductsFromLocalFileSync()
//        fetchproductsFromLocalFileAsync()
//        fetchProductsFromCSV()
//        Task {
//            await fetchProductsUsingAsyncAwait()
//        }
//        fetchProductsUsingAlamofire()
        fetchProductsUsingAsyncAwaitThrow()
    }
    
    
//    Appraoch 7 - Using async/await/throw
//    VERY VERY IMP
    func fetchProductsUsingAsyncAwaitThrow() {
        Task {
            do {
                let fetchedProducts = try await NetworkManager.fetchProductsUsingAsyncAwaitThrow()
                await MainActor.run {
                    products = fetchedProducts
                }
            } catch let error as AppError {
                print(error.localizedDescription)
            }
        }
    }
    
//    Approach 6 - Fetching products using Alamofire
    func fetchProductsUsingAlamofire() {
        NetworkManager.fetchProductsUsingAlamofire { products, error in
            DispatchQueue.main.async { [weak self] in
                self?.products = products
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
//    Approach 5 - Fetching Products through API using async/await
    func fetchProductsUsingAsyncAwait() async {
        let (products, error) = await NetworkManager.fetchProductsUsingAsyncAwait()
        if let error = error {
            print(error.localizedDescription)
        }
        DispatchQueue.main.async { [weak self] in
            self?.products = products
        }
    }
    
//    Approach 4 - Fetching products through API with Custom Errors with handling of API errors
    func fetchProductsWithApiErrors() {
        NetworkManager.fetchProductsWithApiErrors { products, error in
            if !products.isEmpty {
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
//                print(error)
                //above code won't automatically print the localized error
                print(error.localizedDescription)
            }
            
        }
    }

//    Approach 3 - Fetching products through API with Custom Errors
    func fetchProductsWithCustomError() {
        NetworkManager.fetchProductsWithCustomErrors { products, customError in
            if !products.isEmpty {
                DispatchQueue.main.async { [weak self] in
                    self?.products = products
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        if let products = self?.products, products.count > 0 {
                            self?.products[0].title = "Sheetal changed this!"
                        }
                    }
                }
            }
            if let customError = customError {
                print("Error: \(customError.localizedDescription)")
            }
        }
    }
    
//    Approach 2 - Separating to a network layer
    func fetchproducts() {
        NetworkManager.fetchproductsWithoutCustomErrors { products, error in
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
    func fetchproductsWithoutNetworkLayer() {
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
    
    
//    Loading JSON from a local file - using synchronous fetching
    func fetchproductsFromLocalFileSync() {
        if let url = Bundle.main.url(forResource: "DummyProducts", withExtension: "json") {
            do {
                //note that JSONDecoder takes data as input
                //if you have a string, first convert it into data, then parse
                //also, find a away if JSONDecoder can directly decode from string
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
    
//    Loading from a CSV file
    func fetchProductsFromCSV() {
        if let url = Bundle.main.url(forResource: "DummyProducts", withExtension: "csv") {
            
            //Method 1: Using URLSession
//            Question -
//            Why shouldn't I use URLSession? I want to maintain uniformity between local files
//            and API calls.
//            Why is it recommended to use reading from Data(contentsOf: ) ?
//            Answer -
//            URLSession is for I/O over a network stack
//            Even if you give it a file:// URL, it still goes through extra layers meant for HTTP/HTTPS, FTP, etc.
//
//            This adds unnecessary overhead compared to just reading bytes from disk.
//            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data {
//                    //what is utf8?
//                    if let stringData = String(data: data, encoding: .utf8) {
//                        //cleaning data
//                        //as I was getting an extra space at the end of the file.
//                        let cleanedStringData = stringData.trimmingCharacters(in: .whitespacesAndNewlines)
//                        var rows: [String] = cleanedStringData.components(separatedBy: "\n")
//                        print("rows = \(rows)")
//                        if rows.count > 0 {
//                            rows.remove(at: 0)
//                            var products: [ProductModelForCSV] = []
//                            for row in rows {
//                                let fieldValues: [String] = row.components(separatedBy: ",")
//                                //Ignoring corrupt data row
//                                if fieldValues.count < 6 {
//                                    continue
//                                }
//                                print("\nfieldVlaues = \(fieldValues)")
//                                let product = ProductModelForCSV(productID: fieldValues[0],
//                                                                 productName: fieldValues[1],
//                                                                 category: fieldValues[2],
//                                                                 price: fieldValues[3],
//                                                                 stockQuantity: fieldValues[4],
//                                                                 description: fieldValues[5])
//                                products.append(product)
//                            }
//                            print("logging: fetched products from CSV)")
//                            for product in products {
//                                print(product)
//                            }
//                        }
//                    } else {
//                        print("error converting data to string")
//                    }
//                } else {
//                    print("Error")
//                }
//            }
//            dataTask.resume()
            
            
            //Method 2 - Directly reading from file without URLSession
            DispatchQueue.global().async {
                do {
                    let fileData = try Data(contentsOf: url)
                    //cleanedString
                    guard let stringData = String(data: fileData, encoding: .utf8) else {
                        return
                    }
                    let rows: [String] = stringData.components(separatedBy: "\n")
                    var products: [ProductModelForCSV] = []
                    for row in rows {
                        let fieldValues: [String] = row.components(separatedBy: ",")
                        //ignoring corrupt row data
                        if fieldValues.count < 6 {
                            continue
                        }
                        let product = ProductModelForCSV(productID: fieldValues[0],
                                                         productName: fieldValues[1],
                                                         category: fieldValues[2],
                                                         price: fieldValues[3],
                                                         stockQuantity: fieldValues[4],
                                                         description: fieldValues[5])
                        products.append(product)
                        print(product)
                    }
                    print(products)
                } catch {
                    print(error)
                }
            }
        }
    }
}

// Q.1 - How to capture self weakly inside URLSession.shared.dataTask - DONE
// Q.2. - Understand in-depth the type of values received from a data session closure - data, response, error
// Q.3. - Correct way to write data models - for API response parsing + to be used as data source across views - DONE
// Q.4. - Correct way to handle API responses - in-depth - DONE
// Q.5. - Ideal way to do error handling - creating enum for common error types within the app (specific to app use-case) - DONE
// Q.6. - Modularise code so that a common API manager/NetworkManager is used for API calls - DONE
// Q.7. - How to add proper logs to track API calls
// Q.8. -  How to encode our array of products to json
// Q.9. - How to handle cases when a response has certain keys missing? How to write the data model struct to handle such cases without breaking or throwing errors unnecessarily.- DONE
