//
//  ProductModel.swift
//  Projects-ECommerce
//
//  Created by Admin on 12/08/25.
//

import Foundation


//VERSION 1 - Perfect when you know all the keys will be received in response
//struct ProductModel : Decodable {
//    var id: Int
//    var title: String
//    var price: CGFloat
//    var description: String
//    var category: String
//    var image: String
//    
//    //manual init not needed as struct automatically creates a memberwise initialiser
//}

//-----------------------------------------------

//VERSION 2 - Handling cases when there's a possibility that certain keys might be missing in API response
// but this will require us to always unwrap
//struct ProductModel : Decodable {
//    var id: Int?
//    var title: String?
//    var price: CGFloat?
//    var description: String?
//    var category: String?
//    var image: String?
//    
//    init(id: Int? = nil, title: String? = nil, price: CGFloat? = nil, description: String? = nil, category: String? = nil, image: String? = nil) {
//        self.id = id
//        self.title = title
//        self.price = price
//        self.description = description
//        self.category = category
//        self.image = image
//    }
//}
//Problems with version 2
//1. Everything is optional — type safety is lost
//The compiler no longer enforces that you have required data.
//
//You’ll constantly need to unwrap:
//
//swift
//Copy
//Edit
//if let id = product.id { ... } else { ... }
//This makes code noisy and error-prone.
//
//2. You can’t tell if a value is actually “optional”
//Some fields (like id or title) are probably always present in valid API data.
//
//Making them optional just because decoding might fail hides API contract issues.
//
//If id comes back nil because of a decoding problem, you might proceed with invalid data instead of catching the error early.
//
//3. Silent failure instead of decoding errors
//If the API changes a key name or sends the wrong type, decoding will just give you nil instead of throwing.
//
//This can hide breaking API changes for weeks until a bug is reported.
//
//4. Doesn’t model reality well
//Your type should reflect which fields are required vs optional in the backend schema.
//
//If everything is optional, your model is basically saying:
//"All fields may be missing, and that’s fine" — which is rarely true.
//
//Better Approach
//Mix required and optional based on real API contract:

//-----------------------------------------------

//VERSION 3 - A variation of version 2
//struct ProductModel : Decodable {
//    var id: Int = 0
//    var title: String = ""
//    var price: CGFloat = 0.0
//    var description: String = ""
//    var category: String = ""
//    var image: String = ""
//}
// Problems with version 3
//What’s wrong
//Default values prevent compiler-synthesized decoding from throwing errors
//
//In Decodable synthesis, Swift tries to decode each property.
//
//If decoding a property fails (e.g., missing key, wrong type), instead of giving you a decoding error, Swift will still set your default value.
//
//That means you might silently get partial or completely wrong data without knowing.
//
//Example:
//If JSON is missing "price", you’ll just get 0.0 — and no error.
//This is dangerous for debugging and data integrity.
//
//Loss of intent
//
//A property with a default value in a Decodable model reads as "this always has a meaningful default".
//
//But in reality, if the API omits a field, maybe that’s a critical issue — you want decoding to fail, not hide it.
//
//Not distinguishing between “missing” and “real default”
//
//There’s no way to tell if price = 0.0 came from the server or if it’s a fallback because the JSON key was missing.
//
//A better approach for optional fields is var price: CGFloat? — then you know if it was missing.

//-----------------------------------------------

//VERSION 4 - If I want ProductModel to be observable for internal changes in properties
class ProductModel : Decodable, ObservableObject {
    @Published var id: Int
    @Published var title: String
    @Published var price: CGFloat
    @Published var description: String
    @Published var category: String
    @Published var image: String
    
    
    //why is the term 'required' necessary here?
    //we need to add this init from decoder manually because, a class can't automatically synthesize initialisers if it has 'property wrappers'
    //if a class does not have property wrappers at all, it can automatically synthesize the decoder init
    //in order to write manula decoder init, you also need to define your coding keys in this case
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(CGFloat.self, forKey: .price)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        image = try container.decode(String.self, forKey: .image)
        //should I also set default values above?
        //not here - because here we are considering that all keys will definitely be present
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case description
        case category
        case image
    }

}


//-----------------------------------------------

//VERSION 5 - I want ProductModel to be observable and also have the possibility of receiving API responses, with certain keys missing

//TO DO -----------------------------------------


