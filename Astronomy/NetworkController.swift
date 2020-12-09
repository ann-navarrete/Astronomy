import Foundation
import UIKit

class NetworkController {
    
    var baseUrl: String
    var session: URLSession
    var apiKey: String
    
    init(baseUrl: String, session: URLSession, apiKey: String) {
        self.baseUrl = baseUrl
        self.session = session
        self.apiKey = apiKey
    }
    
    func fetchPhotoInfo(date: Date, completion: @escaping (PhotoInfo) -> Void) {
        let url = urlBuilder(date: date)
        let task = self.session.dataTask(with: url) {
            (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
               let photoInfo = try?
                jsonDecoder.decode(PhotoInfo.self, from: data) {
                completion(photoInfo)
            }
        }
        task.resume()
    }
    
    func urlBuilder(date: Date) -> URL {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let baseURL = URL(string: self.baseUrl)!
        let query: [String: String] = [
            "api_key": self.apiKey,
            "date": dateFormatter.string(from: date)
        ]
        return baseURL.withQueries(query)!
    }

    func fetchImge(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

}

extension URL {
      func withQueries(_ queries: [String: String]) -> URL? {
          var components = URLComponents(url: self,
          resolvingAgainstBaseURL: true)
          components?.queryItems = queries.map
  { URLQueryItem(name: $0.0, value: $0.1) }
          return components?.url
      }
}
