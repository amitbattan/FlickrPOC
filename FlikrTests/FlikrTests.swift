//
//  FlikrTests.swift
//  FlikrTests
//
//  Created by Amit Battan on 23/06/18.
//  Copyright © 2018 Amit Battan. All rights reserved.
//

import XCTest
@testable import Flikr

class WebServiceManagerMock: WebServiceManager {

    override func fetch(urlRequest: URLRequest, responseType: ResponseType, completionHandler: @escaping (URLRequest, Any?, Error?) -> Void) -> URLSessionTask {

        do {
            if let file = Bundle(for: type(of: self)).url(forResource: "data", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                completionHandler(urlRequest, json, nil)
            } else {
                completionHandler(urlRequest, nil, nil)
            }
        } catch {
            completionHandler(urlRequest, nil, error)
        }
        return URLSessionTask()
    }
}

class FlikrTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let model = FlickrListModel(searchString: "sometext")
        model.webserviceManager = WebServiceManagerMock(configuration: URLSessionConfiguration.default)
        model.getFlikrList {
            assert(model.flikrList.count == 10)
            assert(model.totalPages == 120183)
            let flickrPhoto = model.flikrList[0]
            assert(flickrPhoto.imageUrl() == "https://farm2.static.flickr.com/1829/41192965510_6f888aa98a.jpg")
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
