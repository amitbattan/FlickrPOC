//
//  FlikrListModel.swift
//  Flikr
//
//  Created by Amit Battan on 23/06/18.
//  Copyright © 2018 Amit Battan. All rights reserved.
//

import Foundation

class FlickrListModel {
    var totalPages:Int = 0
    var currentPage:Int = 1
    var endOfList:Bool = false
    var someError:Bool = false
    
    private var searchKey:String
    private var task:URLSessionTask?
    private (set) var flikrList = [FlickrPhoto]()
    

    lazy var webserviceManager = WebServiceManager.shared

    init(searchString:String) {
        searchKey = searchString
    }

    func cancelRequest() {
        task?.cancel()
    }
    
    func getFlikrList(complition:(()->Void)?) {
        someError = false
        let request = FlickrRequestBuilder().requesForFlickrImages(searchKey: searchKey, currentPage: currentPage)
        task = self.webserviceManager.fetch(urlRequest: request) { [weak self] (_, response, error) in
            self?.flikrAPIHandler(error: error, response: response, complition: complition)
        }
    }
    
    func flikrAPIHandler(error:Error?, response:Any?, complition:(()->Void)?) {
        guard error == nil else {
            someError = true
            complition?()
            return
        }
        
        guard let response = response as? [String:Any], let photos = response["photos"] as? [String:Any] else {
            someError = true
            complition?()
            return
        }
        if let pages = photos["pages"] as? Int {
            totalPages = pages
        }
        if currentPage >= totalPages {
            self.endOfList = true
        }
        currentPage += 1

        if let photo = photos["photo"] as? [Any] {
            let list = photo.compactMap({ object -> FlickrPhoto? in
                if let object = object as? [String:Any] {
                    return FlickrPhoto(dict: object)
                }
                return nil
            })
            self.flikrList.append(contentsOf: list)
        }
        complition?()
    }
    
    func pagingEnable() -> Bool {
        if flikrList.count < totalPages {
            return true
        }
        return false
    }
}
