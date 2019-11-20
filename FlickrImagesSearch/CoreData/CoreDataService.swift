//
//  CoreDataService.swift
//  FlickrImagesSearch
//
//  Created by Вика on 20/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import CoreData
import UIKit

protocol CoreDataServiceProtocol {
    func saveImages(images: [UIImage], completion: @escaping () -> Void)
    func fetchImages(perPage: Int,
                     page: Int,
                     completion: @escaping ([UIImage]) -> Void)
}

class CoreDataService: CoreDataServiceProtocol {
    private let stack = CoreDataStack.shared

    func saveImages(images: [UIImage], completion: @escaping () -> Void) {
        stack.persistentContainer.performBackgroundTask { context in
            defer {
                completion()
            }
            for image in images {
                guard let data = image.jpegData(compressionQuality: 1.0) else { return }
                _ = MOImage(context: context, data: data)
            }
            print("Storing Data..")
            do {
                try context.save()
            } catch {
                print("Storing data Failed")
            }
        }
    }

    func fetchImages(perPage: Int,
                     page: Int,
                     completion: @escaping ([UIImage]) -> Void) {
        stack.persistentContainer.performBackgroundTask { context in
            let request: NSFetchRequest<MOImage> = MOImage.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.fetchLimit = perPage
            request.fetchOffset = perPage * (page - 1)
            print("Fetching Data (fetchLimit = \(request.fetchLimit), fetchOffset = \(request.fetchOffset))")
            do {
                let result = try context.fetch(request)
                    .compactMap { $0.image }
                    .compactMap { UIImage(data: $0 as Data, scale: 1.0) }
                
                print("Fetched \(result.count) images")
                completion(result)
            } catch {
                print("Fetching data Failed")
                completion([])
            }
        }
    }
}
