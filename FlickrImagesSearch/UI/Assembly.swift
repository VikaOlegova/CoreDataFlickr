//
//  Assembly.swift
//  FlickrImagesSearch
//
//  Created by Вика on 10/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

class Assembly {
    func createModule() -> UIViewController {
        let networkService = NetworkService()
        let flickrService = FlickrService(networkService: networkService)
        let flickrLoader = FlickrLoaderService(flickrService: flickrService)
        let coreDataService = CoreDataService()
        let coreDataPaginationService = CoreDataPaginationService(coreDataService: coreDataService,
                                                                  flickrLoader: flickrLoader, pageSize: 5)

        let presenter = Presenter(coreDataService: coreDataPaginationService, pageSize: 5)
        let viewController = ViewController(presenter: presenter)
        presenter.view = viewController

        coreDataPaginationService.delegate = presenter

        return viewController
    }
}
