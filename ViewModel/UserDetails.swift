//
//  UserDetails.swift
//  MVVM using Binding
//
// 
//

import Foundation
import CoreData

private let kYSSDBContextKey = "YSSmanagedObjectContext"

class UserDetails: NSManagedObject, Codable {
    @NSManaged var name: String?
    @NSManaged var email: String?
    @NSManaged var userDetailID: Int16
    @NSManaged var userDetailsToDepartment: Department?

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case userDetailID = "id"
        case userDetailsToDepartment
    }

    static public func createUserDetails(with data: Data) -> [UserDetails]? {
        let allUser: [UserDetails]? = CoreDataHelper.allEntityValue()
        let context = CoreDataHelper.shared.persistentContainer.viewContext

        for loopValue in allUser ?? [] {
            context.delete(loopValue)
        }
        defer {
            CoreDataHelper.shared.saveContext()
        }
        do {
            let response = try JSONDecoder.withDBContext.decode([UserDetails].self, from: data)

            for loopValue in response {
                loopValue.userDetailsToDepartment = Department.createOrInsertDepartment(from: loopValue)
            }

            return response
        } catch let error {
            print("Can't able to save it in local DB\(error.localizedDescription)")
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
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.userDetailID = try container.decode(Int16.self, forKey: .userDetailID)
        self.userDetailsToDepartment = try container.decodeIfPresent(Department.self, forKey: .userDetailsToDepartment)
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(userDetailID, forKey: .userDetailID)
        try container.encode(userDetailsToDepartment, forKey: .userDetailsToDepartment)
    }
}

extension NSObject {

    final class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

}

extension Decoder {

    var mainDBContext: NSManagedObjectContext {
        guard let codingKey = CodingUserInfoKey(rawValue: kYSSDBContextKey) else {
            fatalError("Can't able to find valid coredata key")
        }
        return (userInfo[codingKey] as? NSManagedObjectContext) ?? CoreDataHelper.shared.persistentContainer.viewContext
    }

}

extension JSONDecoder {

    static var withDBContext: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        guard let codingKey = CodingUserInfoKey(rawValue: kYSSDBContextKey) else { return decoder }

        decoder.userInfo[codingKey] = CoreDataHelper.shared.persistentContainer.viewContext
        return decoder
    }

}
