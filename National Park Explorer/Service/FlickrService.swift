import Foundation
import UIKit

enum FlickrServiceError: Error {
    case RequestFailed
    case CouldNotParseResponse
    case ImageDownloadFailed
}

class FlickrService {
    
    //flickr's dev key, replace with real version
    let apiKey = "9decb81166daf3a6637e9afe7e447231"
    
    func searchPhotos(query: String, completion: @escaping ([FlickrPhotoData]?, Error?) -> Void ) {
        
        let url = buildSearchURL(query: query)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, response, error in
            
            if let results = data {
                do {
                    let decoder = JSONDecoder()
                    let results = try decoder.decode(FlickrResponse.self, from: results)
                    completion(results.photos.photo, nil)
                } catch {
                    print(error) // this is a local constant containing the parsing error
                    completion(nil, FlickrServiceError.CouldNotParseResponse)
                }
            }
            else {
                print(error) // response error - for debugging
                completion(nil, FlickrServiceError.RequestFailed)
            }
        }
        task.resume()
    }
    
    func downloadImage(url: String, completion: @escaping (UIImage?, Error?) -> Void) {
        //todo download image
    }
    
    func buildSearchURL(query: String) -> URL? {
        
        let components: URLComponents = {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.flickr.com"
            components.path = "/services/rest"
            components.queryItems = [
                URLQueryItem(name: "method", value: "flickr.photos.search"),
                URLQueryItem(name: "api_key", value: apiKey),
                URLQueryItem(name: "tags", value: query),
                URLQueryItem(name: "sort", value: "relevance"),
                URLQueryItem(name: "per_page", value: "40"),
                URLQueryItem(name: "format", value: "json"),
                URLQueryItem(name: "nojsoncallback", value: "1")
            ]
            return components
        }()
        
        let url = components.url
        return url
    }
}
