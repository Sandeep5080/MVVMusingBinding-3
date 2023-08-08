//
//  DepartmentViewModel.swift
//  MVVM using Binding
//
//  Created by Yarramsetti Satyasai on 01/06/23.
//

import Foundation

class DepartmentViewModel {
    var departmentCellDataSource = Observable<[Department]>()
    init() {
    }
    func getData() {
        departmentCellDataSource.value = CoreDataHelper.allEntityValue() ?? []
                   }
func noOfCell() -> Int {
        departmentCellDataSource.value?.count ?? 0
    }
}
