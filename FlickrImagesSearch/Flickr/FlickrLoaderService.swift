//
//  FlickrPaginationService.swift
//  FlickrImagesSearch
//
//  Created by Вика on 10/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit

protocol FlickrLoaderServiceProtocol {
    func loadImages(by searchString: String, count: Int, completion: @escaping ([UIImage]) -> Void)
}

class FlickrLoaderService: FlickrLoaderServiceProtocol {

    private let flickrService: FlickrServiceProtocol

    init(flickrService: FlickrServiceProtocol) {
        self.flickrService = flickrService
    }

    func loadImages(by searchString: String, count: Int, completion: @escaping ([UIImage]) -> Void) {
        flickrService.loadImageList(searchString: searchString,
                                    perPage: count) { [flickrService] in
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
