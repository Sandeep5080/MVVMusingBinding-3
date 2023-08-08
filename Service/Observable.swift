//
//  Observable.swift
//  MVVM using Binding
//
//  
//

import Foundation

class Observable<T> {
    var value: T? {
    didSet {
       listener?(value)
        }
         }

    private var listener: ((T?) -> Void)?
    func bind(listener: @escaping (T?) -> Void) {
    self.listener = listener
    listener(value)
}
}
