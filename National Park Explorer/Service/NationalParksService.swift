import Foundation

class NationalParksService {
    
    func fetchParks(for state: String, completion: @escaping ([NationalPark]?, Error?) -> Void) {
        
        //example - all parks in Arizona https://api.gov/api/v1/parks?stateCode=az
        
        let components: URLComponents = {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.nps.gov"
            components.path = "/api/v1/parks"
            components.queryItems = [
                URLQueryItem(name: "stateCode", value: state),
            ]
            return components
        }()
        
        let url = components.url
        
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { data, reponse, error in
            
            if let results = data {
                let decoder = JSONDecoder()
                print(data) // for debugging
                
                do {
                    let results = try decoder.decode(NationalParkResult.self, from: results)
                    completion(results.data, nil)
                } catch {
                    print(error) //local error var, containing decoder error
                    completion(nil, NationalParksServiceError.ResponseParsingError)
                }
            }
            else {
                print(error)
                completion(nil, NationalParksServiceError.RequestError)
            }
            //todo error handling
        }
        
        task.resume()
    }
}

enum NationalParksServiceError: Error {
    case RequestError
    case ResponseParsingError
}
