//
//  DepartmentViewController.swift
//  MVVM using Binding
//
//  Created by Yarramsetti Satyasai on 01/06/23.
//

import UIKit

class DepartmentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.noOfCell()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentTableViewCell", for: indexPath)
                as? DepartmentTableViewCell else {
                return UITableViewCell()
            }
            guard  let departmentobj = viewmodel.departmentCellDataSource.value?[indexPath.row]
            else {
              return UITableViewCell()
          }
        cell.departmentname.text = "\(departmentobj.departmentName)\nUser list:\n \(departmentobj.allUserName)"
            return cell
    }
    @IBOutlet weak var departmentTableview: UITableView!
    private var viewmodel = DepartmentViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewbind()
        viewmodel.getData()
        departmentTableview.delegate = self
        departmentTableview.dataSource = self
    }
    func viewbind() {
        viewmodel.departmentCellDataSource.bind {_ in
            DispatchQueue.main.async {
                self.departmentTableview.reloadData()
            }
            }
        }
}
