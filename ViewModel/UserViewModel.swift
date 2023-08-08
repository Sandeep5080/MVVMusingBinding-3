//
//  UserViewModel.swift
//  MVVM using Binding
//
//  
//

import Foundation
class UserViewModel {
    var usersCellDataSource = Observable<[UserDetails]>()
    private var service: NetworkService
    var userData = [User]()
    init(service: NetworkService = NetworkService()) {
        self.service = service
    }
    func getUserData() {
//        self.usersCellDataSource.value = CoreDataHelper.allEntityValue()
        service.fetchUser { [weak self] data, _  in
            guard let data else { return }
            self?.usersCellDataSource.value = UserDetails.createUserDetails(with: data)

//            dump(userData)
//            self?.mapCellDataSource()

        }
    }
func noOfCell() -> Int {
        usersCellDataSource.value?.count ?? 0
    }
}
