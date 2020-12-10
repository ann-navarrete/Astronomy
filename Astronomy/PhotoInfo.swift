import Foundation

struct PhotoInfo: Codable, Equatable {
    var title: String
    var description: String
    var url: URL
//    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
//        case copyright
    }
    
    static func == (lhs: PhotoInfo, rhs: PhotoInfo) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description && lhs.url == rhs.url
    }
}
