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
    
    private let coreDataService: CoreDataPaginationServiceProtocol
    
    init(coreDataService: CoreDataPaginationServiceProtocol, pageSize: Int) {
        self.coreDataService = coreDataService
        self.pageSize = pageSize
    }
    
    func loadFirstPage(searchString: String) {
        self.searchString = searchString
        
        guard !searchString.isEmpty else { return }
        
        coreDataService.loadFirstPage(by: searchString)
        view?.showLoadingIndicator(true)
    }
    
    func loadNextPage() {
        guard coreDataService.loadNextPage() else { return }
        view?.showLoadingIndicator(true)
    }
}

extension Presenter: CoreDataPaginationServiceDelegate {
    func coreDataPaginationService(_ service: CoreDataPaginationServiceProtocol,
                                 didLoad images: [UIImage],
                                 on page: Int) {
 
        view?.show(images: images, firstPage: page == 1)
        view?.showLoadingIndicator(false)
    }
}
