import XCTest
@testable import Astronomy

class AstronomyTests: XCTestCase {
    
    var networkController: NetworkController!
    var urlProtocolMock: URLProtocolMock!
    
    // add instance of the validation service
    override func setUp() {
        super.setUp()
        // now set up configuration to use our mock
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        
        // and create the URLSession from that
        let session = URLSession(configuration: config)
        
        networkController = NetworkController(baseUrl: "https://api.nasa.gov/", session: session, apiKey: "8nyjHCztYC0pLw1KKZ4APLXhgaQI4TvUA7HahTeL")
    }
    
    override func tearDown() {
        networkController = nil
    }
    
    func createDate(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
        
    func testUrlBuilder() {
        // arrange
        let expectedBaseUrl = "https://api.nasa.gov/planetary/apod?"
        let expectedDate = "date=2020-12-08"
        let expectedApiKey = "api_key=8nyjHCztYC0pLw1KKZ4APLXhgaQI4TvUA7HahTeL"
        let date = createDate(year: 2020, month: 12, day: 8)
        
        // act
        let actual = networkController.urlBuilder(date: date)
        
        // assert -- multiple assert, don't need to check for the full URL
        XCTAssertNotNil(actual.absoluteString.range(of: expectedBaseUrl))
        XCTAssertNotNil(actual.absoluteString.range(of: expectedDate))
        XCTAssertNotNil(actual.absoluteString.range(of: expectedApiKey))
    }
    
    func testFetchPhotoInfo() {
        // this is the URL we expect to call and set mock data
        let url = URL(string: "https://api.nasa.gov/planetary/apod?")!
        let date = createDate(year: 2020, month: 12, day: 10)
        let title = "Arecibo Telescope Collapse"
        let description = "This was one great scientific instrument."
        
        let samplePhotoInfo = PhotoInfo(title: title, description: description, url: url)
        
        let mockData = try! JSONEncoder().encode(samplePhotoInfo)
        URLProtocolMock.testResponse = mockData
        let expectation = XCTestExpectation(description: "response")
        networkController.fetchPhotoInfo(date: date) { (responsePhotoInfo) in
            XCTAssertEqual(responsePhotoInfo, samplePhotoInfo)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
