//
//  NetworkService.swift
//  MVVM using Binding
//

import Foundation

 class NetworkService {
    func fetchUser(completionHandler: @escaping (_: Data?, _ error: Error?) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/")!
        let task =   URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completionHandler(nil, error)
                return
            }

            guard let data = data else {
                print("No data returned from API")
                return
            }
            completionHandler(data, nil)
        }
        task.resume()
    }
}
