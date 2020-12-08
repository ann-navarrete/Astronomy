import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageTitle: UILabel!
    
    @IBOutlet weak var dateSelected: UILabel!
    
    var date: Date?
    
    @IBOutlet weak var imageOfTheDay: UIImageView!
    
    @IBOutlet weak var imageDescription: UITextView!
    
    func fetchPhotoInfo(date: Date, completion: @escaping (PhotoInfo) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        let query: [String: String] = [
            "api_key": "8nyjHCztYC0pLw1KKZ4APLXhgaQI4TvUA7HahTeL",
            "date": dateFormatter.string(from: date)
        ]
        
        let url = baseURL.withQueries(query)!
        let task = URLSession.shared.dataTask(with: url) {
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Image of the Day"
        
        if let date = date {
            fetchPhotoInfo(date: date) { (photoInfo) in
                self.updateUI(with: photoInfo)
            }
            dateSelected.text = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
        }
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        print(photoInfo)
        DispatchQueue.main.async {
        self.imageTitle.text = photoInfo.title
        self.imageDescription.text = photoInfo.description
        }
        fetchImge(url: photoInfo.url) { (photo) in
            DispatchQueue.main.async {
                self.imageOfTheDay.image = photo
            }
        }
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

struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
    
    init(from decoder: Decoder) throws {
            let valueContainer = try decoder.container(keyedBy:
               CodingKeys.self)
            self.title = try valueContainer.decode(String.self,
               forKey: CodingKeys.title)
            self.description = try
               valueContainer.decode(String.self, forKey:
               CodingKeys.description)
            self.url = try valueContainer.decode(URL.self, forKey:
               CodingKeys.url)
            self.copyright = try? valueContainer.decode(String.self,
               forKey: CodingKeys.copyright)
        }
}

struct Report: Codable {
    let creationDate: Date
    let profileID: String
    let readCount: Int

    enum CodingKeys: String, CodingKey {
        case creationDate = "report_date"
        case profileID = "profile_id"
        case readCount = "read_count"
    }
}

enum CodingKeys: String, CodingKey {
    case title
    case description = "explanation"
    case url
    case copyright
}











