//
//  FlickrRequest.swift
//  Flickr
//
//  Created by Amit Battan on 23/06/18.
//  Copyright © 2018 Amit Battan. All rights reserved.
//

import Foundation

class AppConstants {
    static let baseUrl = "https://api.flickr.com/services/rest/"
    static let method = "flickr.photos.search"
    static let apiKey = "3e7cc266ae2b0e0d78e279ce8e361736"
    static let pageSize = 10
}


class FlickrRequestBuilder {
    
    func requesForFlickrImages(searchKey:String, currentPage:Int) -> URLRequest {
        let urlString:String = AppConstants.baseUrl + "?method=\(AppConstants.method)&api_key=\(AppConstants.apiKey)&format=json&nojsoncallback=1&safe_search=1&text=\(searchKey)&per_page=\(AppConstants.pageSize)&page=\(currentPage)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
    func requestForFlickrImage(photoUrl:String) -> URLRequest {
        let urlString:String = photoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    
}

