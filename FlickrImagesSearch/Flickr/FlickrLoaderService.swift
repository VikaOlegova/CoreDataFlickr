//
//  FlickrPaginationService.swift
//  FlickrImagesSearch
//
//  Created by Вика on 10/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol FlickrLoaderServiceProtocol {
    func loadImages(by searchString: String, completion: @escaping ([UIImage]) -> Void)
}

class FlickrLoaderService: FlickrLoaderServiceProtocol {
    var pageSize: Int

    private let flickrService: FlickrServiceProtocol

    init(flickrService: FlickrServiceProtocol, pageSize: Int) {
        self.flickrService = flickrService
        self.pageSize = pageSize
    }

    func loadImages(by searchString: String, completion: @escaping ([UIImage]) -> Void) {
        flickrService.loadImageList(searchString: searchString,
                                    perPage: pageSize) { [flickrService] in
            print("got \($0.count) urls")
            flickrService.loadUIImages(for: $0,
                                       completion: {
                                           let images = $0.compactMap { $0.uiImage }
                                           print("downloaded \($0.count) images")
                                           completion(images)
            })
        }
    }
}
