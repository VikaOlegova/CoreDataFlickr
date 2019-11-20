//
//  CoreDataStack.swift
//  FlickrImagesSearch
//
//  Created by Вика on 20/11/2019.
//  Copyright © 2019 Vika Olegova. All rights reserved.
//

import CoreData
import Foundation

internal final class CoreDataStack {
    static let shared = CoreDataStack()

    let persistentContainer: NSPersistentContainer

    private init() {
        let group = DispatchGroup()

        persistentContainer = NSPersistentContainer(name: "Model")
        group.enter()
        persistentContainer.loadPersistentStores { storeDescription, error in
            print("storeDescription = \(storeDescription)")
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            group.leave()
        }
        group.wait()
    }

    func clear(completion: @escaping () -> Void) {
        persistentContainer.performBackgroundTask { context in
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: MOImage.fetchRequest())
            _ = try? context.execute(deleteRequest)
            try? context.save()
            completion()
        }
    }
}
