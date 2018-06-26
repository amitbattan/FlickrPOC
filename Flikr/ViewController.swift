//
//  ViewController.swift
//  Flickr
//
//  Created by Amit Battan on 23/06/18.
//  Copyright © 2018 Amit Battan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FlickrListViewModelProtocol {
    
    var viewModel:FlickrListViewModel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FlickrListViewModel()
        viewModel.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - UISearchBar Delgate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchBarText = searchBar.text {
            viewModel.startSearch(for: searchBarText)
        }
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 1
        default:
            return viewModel.numberOfRow()
        }
    }

    lazy var webserviceManager = WebServiceManager.shared
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0, let cell = cell as? FlickrPhotoCell {
            if let photoVM:PhotoViewModel = viewModel.photo(at: indexPath.row) {
                let request = FlickrRequestBuilder().requestForFlickrImage(photoUrl: photoVM.photoUrl)
                cell.flickrPhoto.image = UIImage(named: "default-img")
                self.webserviceManager.fetch(urlRequest: request, responseType: .image) { [weak self] (url, response, error) in
                    guard let weakSelf = self, let image = response as? UIImage else {
                        return
                    }
                    if let visibleCell = weakSelf.tableView.cellForRow(at: indexPath) as? FlickrPhotoCell {
                        visibleCell.flickrPhoto.image = image
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            viewModel.fetchNextPage()
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlikrListMessageCell", for: indexPath) as! FlikrListMessageCell
            cell.messageLabel.text = viewModel.flikrListCurrentState()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlikrPhotoCell", for: indexPath) as! FlickrPhotoCell
            if let photoVM:PhotoViewModel = viewModel.photo(at: indexPath.row) {
                cell.titleLabel.text = photoVM.title
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            viewModel.retryIfNeeded()
        default: break
        }
    }
    
    //MARK: FlikrList ViewModel Protocol
    func updateList() {
        tableView.reloadData()
    }
}

class FlickrPhotoCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var flickrPhoto:UIImageView!
}

class FlikrListMessageCell: UITableViewCell {
    @IBOutlet weak var messageLabel:UILabel!
}
