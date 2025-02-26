//
//  AtributoTableViewCell.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 25/02/25.
//

import UIKit

class AtributoTableViewCell: UITableViewCell {

    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
