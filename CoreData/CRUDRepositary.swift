//
//  CRUDRepositary.swift
//  MVVM using Binding
//
//  Created by Yarramsetti Satyasai on 25/05/23.
//

import Foundation
import UIKit
import CoreData
class CoreDataHelper {
    static let shared = CoreDataHelper()

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MVVMCore")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
       if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
        // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
static public func basicFetchRequest<T: NSManagedObject>() -> NSFetchRequest<T> {
        guard let fetch = T.fetchRequest() as? NSFetchRequest<T>,
              !(fetch.entityName ?? "").isEmpty else {
            let fetchRequest = NSFetchRequest<T>.init(entityName: T.className)
            return fetchRequest
        }
        return fetch
    }

    static public func allEntityValue<T: NSManagedObject>() -> [T]? {
        let fetchRequest: NSFetchRequest<T> = basicFetchRequest()

        do {
            let results: [T] = try CoreDataHelper.shared.persistentContainer.viewContext.fetch(fetchRequest)
            return results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
//        func saveData(users: [User]) {
//            guard let appDelegateObject = appDelegate
//            else {
//                return
//           }
//            let context = appDelegateObject.persistentContainer.viewContext
//            for user in users {
//                let coreDataUserObject = UserDetails(context: context)
//                coreDataUserObject.email = user.email
//                coreDataUserObject.name = user.name
//            }
//            appDelegateObject.saveContext()
//        }
//      func deleteData(index: Int) {
//
//       if let dataArray = fetchData() {
//                appDelegate?.persistentContainer.viewContext.delete(dataArray[index])
//                do {
//                    try appDelegate?.persistentContainer.viewContext.save()
//                } catch {                   print("error: \(error.localizedDescription)")
//                }
//            }
//        }
    }

extension String {

    func createEntity<T: NSManagedObject>(inContext: NSManagedObjectContext) -> T? {
        let object: AnyObject = NSEntityDescription.insertNewObject(forEntityName: self, into: inContext)
        return object as? T
    }

}
