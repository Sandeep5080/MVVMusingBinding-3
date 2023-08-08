//
//  UserdataTableViewCell.swift
//  MVVM using Binding
//
//  
//

import Foundation
import UIKit

class UserdataTableViewCell: UITableViewCell {

    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
