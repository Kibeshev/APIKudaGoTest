//
//  KGCell.swift
//  ApiKudagoTest
//
//  Created by Кирилл Кибешев on 04.03.2019.
//  Copyright © 2019 Кирилл Кибешев. All rights reserved.
//

import UIKit

class KGCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescriotions: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
