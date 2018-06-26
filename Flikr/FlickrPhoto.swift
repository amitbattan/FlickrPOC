//
//  FlikrModel.swift
//  Flikr
//
//  Created by Amit Battan on 23/06/18.
//  Copyright © 2018 Amit Battan. All rights reserved.
//

import Foundation

class FlickrPhoto {
    var photoId:String
    var secret:String
    var farm:Int
    var server:String

    var owner:String?
    var title:String?
    
    init?(dict:[String:Any]) {
        guard let id = dict["id"] as? String, let secret = dict["secret"] as? String,
            let farm = dict["farm"] as? Int, let server = dict["server"] as? String else {
            return nil
        }
        self.photoId = id
        self.secret = secret
        self.server = server
        self.farm = farm
        
        if let owner = dict["owner"] as? String {
            self.owner = owner
        }
        
        if let title = dict["title"] as? String {
            self.title = title
        }
    }
    
    func imageUrl() -> String {
        let urlString:String = "https://farm\(farm).static.flickr.com/\(server)/\(photoId)_\(secret).jpg"
        return urlString
    }
    
}
