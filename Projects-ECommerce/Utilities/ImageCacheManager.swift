//
//  ImageCacheManager.swift
//  Projects-ECommerce
//
//  Created by Admin on 24/08/25.
//

import Foundation
import SwiftUI


// Method 1 - Using NSCache (not an ideal approach for media files)

class ImageCacheManager {
    static var shared: ImageCacheManager = ImageCacheManager()
    
    var cachedImages = NSCache<NSString, NSData>()
    
    private init() { }
    
    public func getImage(for url: String, _ completionHandler: @escaping ((Image?) -> Void) ) {
        
        //Loading from cache
        let urlString = url as NSString
        if let cachedImageData = cachedImages.object(forKey: urlString) {
            let data = Data(referencing: cachedImageData)
            //this is not an ideal approach as image is being rendered first from uiImage and then to Image
            //which fails the purpose of using cache i.e. faster access
            if let uiImage = UIImage(data: data) {
                completionHandler(Image(uiImage: uiImage))
            } else {
                completionHandler(nil)
            }
        }
        
        //If cache loading fails, fetch image freshly from url
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            //Q. Is weak self needed in singleton? Can singleton be deallocated while the bg thread still exists
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                if let data = data, let uiImage = UIImage(data: data) {
                    self?.cachedImages.setObject(data as NSData, forKey: urlString)
                    completionHandler(Image(uiImage: uiImage))
                }
            }
            dataTask.resume()
        }
        completionHandler(nil)
    }
}


// Questions:
// 1. How to convert image to data, if we want to cache it as data, rather than image?
// 2. Async image probably already has the caching ability. Try that.

// Notes:
// 1- You cannot save Image() in an NSCache dictionary (as <urlstring: imageObject>)
// as it wants a class object in in its Key and Value.
// 2 - You can save UIImage() in an NSCache as UIImage is a class object
// 3 - You might think you could convert Image to NSData or Image to UIImage.
// 4 - But, probably Image to Data conversion is not possible
// 5 - Image to UIImage conversion is possible but is computationally intensive
// 6 - However, you can write the data fetched from urlstring (of image) directly to a file, or store it in NSCache, before rendering it as an image.
// 7 - This would require us to create our own customized ImageView, that fetches image from urlString and is also responsible for saving and fetching cached images.
