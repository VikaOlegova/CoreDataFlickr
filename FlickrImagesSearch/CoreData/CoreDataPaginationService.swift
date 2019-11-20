//
//  CoreDataPaginationService.swift
//  FlickrImagesSearch
//
//  Created by Вика on 20/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol CoreDataPaginationServiceProtocol {
    func loadFirstPage(by searchString: String)
    func loadNextPage() -> Bool
}

protocol CoreDataPaginationServiceDelegate: class {
    func coreDataPaginationService(_ service: CoreDataPaginationServiceProtocol,
                                   didLoad images: [UIImage],
                                   on page: Int)
}

class CoreDataPaginationService: CoreDataPaginationServiceProtocol {
    weak var delegate: CoreDataPaginationServiceDelegate?

    var pageSize: Int

    private(set) var isLoadingNextPage = false
    private(set) var nextPage = 1
    private(set) var searchString: String?

    private let flickrLoader: FlickrLoaderServiceProtocol
    private let coreDataService: CoreDataServiceProtocol

    init(coreDataService: CoreDataServiceProtocol,
         flickrLoader: FlickrLoaderServiceProtocol,
         pageSize: Int) {
        self.coreDataService = coreDataService
        self.flickrLoader = flickrLoader
        self.pageSize = pageSize
    }

    func loadFirstPage(by searchString: String) {
        nextPage = 1
        self.searchString = searchString
        _ = loadNextPage()
    }

    func loadNextPage() -> Bool {
        guard
            let searchString = searchString,
            nextPage == 1 || !isLoadingNextPage
        else { return false }

        isLoadingNextPage = true

        let page = nextPage
        nextPage += 1

        func loadNextPageFromCoreData() {
            coreDataService.fetchImages(perPage: pageSize, page: page) { [weak self] in
                guard let self = self else { return }
                
                self.delegate?.coreDataPaginationService(self, didLoad: $0, on: page)
            }
        }

        func downloadImages() {
            flickrLoader.loadImages(by: searchString, count: 100) { [weak self] in
                self?.coreDataService.saveImages(images: $0) {
                    loadNextPageFromCoreData()
                }
            }
        }

        coreDataService.fetchImages(perPage: pageSize, page: page) { [weak self] in
            guard let self = self else { return }
            
            self.isLoadingNextPage = false
            if page == 1, $0.isEmpty {
                downloadImages()
                return
            }
            self.delegate?.coreDataPaginationService(self, didLoad: $0, on: page)
        }
        return true
    }
}
