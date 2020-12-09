import UIKit

class ImageViewController: UIViewController {
    
    var date: Date?
    
    let networkController = NetworkController(baseUrl:  "https://api.nasa.gov/planetary/apod", session: URLSession.shared, apiKey: "8nyjHCztYC0pLw1KKZ4APLXhgaQI4TvUA7HahTeL")
    
    @IBOutlet weak var imageTitle: UILabel!
    
    @IBOutlet weak var dateSelected: UILabel!
    
    @IBOutlet weak var imageOfTheDay: UIImageView!
    
    @IBOutlet weak var imageDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Image of the Day"
        
        if let date = date {
            networkController.fetchPhotoInfo(date: date) { (photoInfo) in
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
        networkController.fetchImge(url: photoInfo.url) { (photo) in
            DispatchQueue.main.async {
                self.imageOfTheDay.image = photo
            }
        }
    }
}











