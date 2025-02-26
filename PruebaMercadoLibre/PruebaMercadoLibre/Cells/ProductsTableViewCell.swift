//
//  ProductsTableViewCell.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 25/02/25.
//

import UIKit

class ProductsTableViewCell: UITableViewCell {

    @IBOutlet weak var productoImageView: UIImageView!
    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var precioAnteriorLabel: UILabel!
    @IBOutlet weak var precioActualLabel: UILabel!
    @IBOutlet weak var porcentajeDescuentoLabel: UILabel!
    let atributoTachado: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
