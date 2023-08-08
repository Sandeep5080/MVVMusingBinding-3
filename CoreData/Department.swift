//
//  Department.swift
//  MVVM using Binding
//
//  Created by Mathi Arasan D V on 06/06/23.
//

import Foundation
import CoreData

class Department: NSManagedObject, Codable {
    @NSManaged public var departmentID: Int16
    @NSManaged public var departmenttouserdetails: Set<UserDetails>?

    enum CodingKeys: CodingKey {
        case departmentID
        case departmenttouserdetails
    }

    var departmentName: String {
        Department.departmentName(from: departmentID)
    }

    var allUserName: String {
        var returnString = ""
        for loopValue in departmenttouserdetails ?? [] {
            returnString+="\(loopValue.name ?? "")\n"
        }

        return returnString
    }

    private class func departmentName(from value: Int16) -> String {
        switch value {
        case 0: return "CSE"
        case 1: return "ECE"
        case 2: return "ME"
        case 3: return "CE"
        default: return "Unknown"
        }
    }

    class func createOrInsertDepartment(from userDetail: UserDetails) -> Department {
        let depID = userDetail.userDetailID % 4
        if let haveBLEDevice = department(forID: depID) {
            return haveBLEDevice
        }
        let viewContext = CoreDataHelper.shared.persistentContainer.viewContext
        guard let newDep: Department = Department.className.createEntity(inContext: viewContext) else {
            fatalError("Can't able to create DB")
        }

        newDep.departmentID = depID

        if var oldUser = newDep.departmenttouserdetails {
            oldUser.insert(userDetail)
            newDep.departmenttouserdetails = oldUser
        } else {
            newDep.departmenttouserdetails = [userDetail]
        }

        return newDep
    }

    class func department(forID: Int16) -> Department? {
        let fetchedRequest = NSFetchRequest<Department>(entityName: "Department")
        let managedContext = CoreDataHelper.shared.persistentContainer.viewContext
        let searchString = NSStringFromSelector(#selector(getter: Department.departmentID))
        let predicate = NSPredicate(format: "\(searchString) == \(forID)")
        fetchedRequest.predicate = predicate
        fetchedRequest.fetchLimit = 1

        do {
            let fetchResult: [Department] = try managedContext.fetch(fetchedRequest)
            if !fetchResult.isEmpty,
               let lastObject = fetchResult.last {
                return lastObject
            }
        } catch {
            print("fetch error \(error.localizedDescription)")
        }

        return nil
    }

    // MARK: - Decodable
    public required convenience init(from decoder: Decoder) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: UserDetails.className,
                                                      in: decoder.mainDBContext) else {
            fatalError("Failed to decode User")
        }

        self.init(entity: entity, insertInto: decoder.mainDBContext)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.departmentID = try container.decode(Int16.self, forKey: .departmentID)
        self.departmenttouserdetails = try container.decodeIfPresent(Set<UserDetails>.self, forKey: .departmenttouserdetails)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(departmentID, forKey: .departmentID)
        try container.encode(departmenttouserdetails, forKey: .departmenttouserdetails)
    }

}
