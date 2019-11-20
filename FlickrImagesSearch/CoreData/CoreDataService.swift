//
//  CoreDataService.swift
//  FlickrImagesSearch
//
//  Created by Вика on 20/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import UIKit
import CoreData

protocol CoreDataServiceProtocol {
    
    func saveImages(images: [UIImage], completion: @escaping () -> Void)
    func fetchImages(perPage: Int,
                     page: Int,
                     completion: @escaping ([UIImage]) -> Void)
}

class CoreDataService: CoreDataServiceProtocol {
    
    let stack = CoreDataStack.shared
    
    func saveImages(images: [UIImage], completion: @escaping () -> Void) {
        stack.persistentContainer.performBackgroundTask { (context) in
            defer {
                completion()
            }
            for image in images {
                let newImageObj = MOImage(context: context)
                guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
                let data = NSData(data: imageData)
                newImageObj.image = data
                print("saved \(data.hash) image")
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
        stack.persistentContainer.performBackgroundTask { (context) in
            print("Fetching Data (fetchLimit = \(perPage), fetchOffset = \(perPage * (page - 1))")
            let request: NSFetchRequest<MOImage> = MOImage.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.fetchLimit = perPage
            request.fetchOffset = perPage * (page - 1)
            do {
                let result = try context.fetch(request)
                print("Fetched \(result.count) images")
                completion(result
                    .compactMap { $0.image }
                    .compactMap { UIImage(data: $0 as Data, scale: 1.0) })
            } catch {
                print("Fetching data Failed")
                completion([])
            }
        }
    }
}
