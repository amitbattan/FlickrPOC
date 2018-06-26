//
//  WebServiceManager.swift
//  Flickr
//
//  Created by Amit Battan on 23/06/18.
//  Copyright © 2018 Amit Battan. All rights reserved.
//

import Foundation
import UIKit

enum ResponseType {
    case json
    case image
    case string
    case data
}

class WebServiceManager {
    private let session: URLSession
    
    static let shared:WebServiceManager = {
        return WebServiceManager(configuration: URLSessionConfiguration.default)
    }()
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }
    
    @discardableResult func fetch(urlRequest: URLRequest, responseType:ResponseType = .json, completionHandler: @escaping (URLRequest, Any?, Error?) -> Void) -> URLSessionTask {
        let task = self.session.dataTask(with: urlRequest) { (data, response, sError) in
            var serializedResponse: Any? = nil
            var error:Error? = sError
            
            if let responseData = data {
                switch responseType {
                case .image:
                    serializedResponse = UIImage(data: responseData)
                case .json:
                    do {
                        serializedResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    } catch let error1 as NSError {
                        error = error1
                        print(error1.localizedDescription)
                    } catch {
                        
                    }
                    
                case .string:
                    if let string = NSString(data: responseData, encoding: String.Encoding.utf8.rawValue) as String? {
                        serializedResponse = string
                    }
                    
                default:
                    serializedResponse = responseData
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(urlRequest, serializedResponse, error)
            }
        }
        
        task.resume()
        return task
    }

}
