//
//  DepartmentTableViewCell.swift
//  MVVM using Binding
//
//  Created by Yarramsetti Satyasai on 05/06/23.
//

import UIKit

class DepartmentTableViewCell: UITableViewCell {

    @IBOutlet weak var departmentname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
