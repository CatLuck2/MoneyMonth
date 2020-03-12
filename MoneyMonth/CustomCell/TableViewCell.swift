//
//  TableViewCell.swift
//  MPC
//
//  Created by Nekokichi on 2020/02/25.
//  Copyright © 2020 Nekokichi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var paymentName: UILabel!
    @IBOutlet weak var paymentDay: UILabel!
    @IBOutlet weak var paymentPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
