//
//  FlickrListViewModel.swift
//  Flickr
//
//  Created by Amit Battan on 23/06/18.
//  Copyright © 2018 Amit Battan. All rights reserved.
//

import Foundation

protocol FlickrListViewModelProtocol: class {
    func updateList()
}

class FlickrListViewModel {
    private var flikrList = [FlickrPhoto]()
    private var model:FlickrListModel?
    private var searchText:String?
    private (set) var isLoading:Bool = false
    weak var delegate:FlickrListViewModelProtocol?

    init() {
    }
    
    func startSearch(for searchText:String) {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if searchText == self.searchText {
            //Do Nothing
        } else {
            model?.cancelRequest()
            isLoading = false
            self.searchText = searchText
            model = FlickrListModel(searchString: searchText)
            if searchText != "" {
                fetchList()
            } else {
                flikrList.removeAll()
            }
            delegate?.updateList()
        }
    }

    private func fetchList() {
        guard let _ = searchText, isLoading == false else {
            return
        }
        isLoading = true
        model?.getFlikrList() { [weak self] in
            self?.fetchComplete()
        }
    }
    
    func fetchComplete() {
        isLoading = false
        flikrList = model?.flikrList ?? []
        delegate?.updateList()
    }
    
    func numberOfRow() -> Int {
        return flikrList.count
    }

    func photo(at index:Int) -> PhotoViewModel? {
        if flikrList.count > index {
            return PhotoViewModel(photo: flikrList[index])
        }
        return nil
    }
    
    func flikrListCurrentState() -> String {
        if searchText == nil || searchText == "" {
            return "search something"
        }
        if model?.someError == true {
            return "something went wrong, tap here to retry"
        }
        if model?.endOfList == true {
            return "no more image available"
        }
        if flikrList.count == 0 {
            return "no result found"
        }
        return "loading..."
    }
    
    func retryIfNeeded() {
        guard searchText != nil else {
            return
        }
        if model?.someError == true || isLoading == false {
            fetchList()
        }
    }
    
    func fetchNextPage() {
        if model?.pagingEnable() == true, model?.someError == false {
            fetchList()
        }
    }
    

}

class PhotoViewModel {
    var photoUrl:String
    var title:String
    
    init(photo:FlickrPhoto) {
        self.photoUrl = photo.imageUrl()
        self.title = photo.title ?? "-"
    }
}
