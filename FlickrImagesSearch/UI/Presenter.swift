//
//  Presenter.swift
//  FlickrImagesSearch
//
//  Created by Вика on 10/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol PresenterInput {
    
    func loadFirstPage(searchString: String)
    func loadNextPage()
}

protocol PresenterOutput: class {
    
    func showLoadingIndicator(_ show: Bool)
    func show(images: [UIImage], firstPage: Bool)
}

class Presenter: PresenterInput {
    
    weak var view: PresenterOutput?
    
    var pageSize: Int
    
    private(set) var images = [UIImage]()
    private(set) var searchString = ""
    
    private let flickrService: FlickrPaginationServiceProtocol
    
    init(flickrService: FlickrPaginationServiceProtocol, pageSize: Int = 5) {
        self.flickrService = flickrService
        self.pageSize = pageSize
    }
    
    func loadFirstPage(searchString: String) {
        self.searchString = searchString
        
        guard !searchString.isEmpty else { return }
        
        flickrService.loadFirstPage(by: searchString)
        view?.showLoadingIndicator(true)
    }
    
    func loadNextPage() {
        guard flickrService.loadNextPage() else { return }
        view?.showLoadingIndicator(true)
    }
}

extension Presenter: FlickrPaginationServiceDelegate {
    func flickrPaginationService(_ service: FlickrPaginationServiceProtocol,
                                 didLoad images: [FlickrImage],
                                 on page: Int,
                                 by searchString: String) {
        guard searchString == self.searchString else {
            return
        }
        let viewModels: [UIImage] = images.compactMap {
            guard let uiImage = $0.uiImage else { return nil }
            return uiImage
        }
        view?.show(images: viewModels, firstPage: page == 1)
        view?.showLoadingIndicator(false)
    }
}
