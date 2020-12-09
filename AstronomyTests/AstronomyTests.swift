import XCTest
@testable import Astronomy

class AstronomyTests: XCTestCase {
    
    var networkController: NetworkController!
    
    // add instance of the validation service
    override func setUp() {
        super.setUp()
        networkController = NetworkController(baseUrl: "https://api.nasa.gov/planetary/apod", session: URLSession.shared, apiKey: "8nyjHCztYC0pLw1KKZ4APLXhgaQI4TvUA7HahTeL")
    }
    
    override func tearDown() {
        networkController = nil
    }
        
    func testUrlBuilder() {
        // arrange
        let expected = URL(string: "https://api.nasa.gov/planetary/apod?api_key=8nyjHCztYC0pLw1KKZ4APLXhgaQI4TvUA7HahTeL&date=2020-12-08")
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        var dateComponents = DateComponents()
            dateComponents.year = 2020
            dateComponents.month = 12
            dateComponents.day = 8
        let date = gregorianCalendar.date(from: dateComponents)!
        
        // act
        let actual = networkController.urlBuilder(date: date)
        
        // assert -- multiple assert, don't need to check for the full URL
        // date
        // api key
        XCTAssertEqual(expected, actual)
    }
}
