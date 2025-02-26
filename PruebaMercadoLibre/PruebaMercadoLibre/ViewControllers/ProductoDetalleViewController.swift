//
//  ProductoDetalleViewController.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 25/02/25.
//

import UIKit

class ProductoDetalleViewController: UIViewController {

    var producto: Producto?
    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var precioAnteriorLabel: UILabel!
    @IBOutlet weak var precioActualLabel: UILabel!
    @IBOutlet weak var porcentajeDescuentoLabel: UILabel!
    @IBOutlet weak var productoImageView: UIImageView!
    @IBOutlet weak var atributosTableView: UITableView!
    let atributoTachado: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
    
    @IBOutlet weak var vendedorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        atributosTableView.delegate = self
        atributosTableView.dataSource = self
        //Mostramos los campos en la vista
        if let producto = producto {
            tituloLabel.text = producto.title
            if(producto.discount_percentage > 0){
                porcentajeDescuentoLabel.text = producto.discount_percentage.formatted(.number) + "%"
                porcentajeDescuentoLabel.isHidden = false
            }
            else{
                porcentajeDescuentoLabel.text = ""
                porcentajeDescuentoLabel.isHidden = true
            }
            
            if(producto.original_price > 0){
                precioAnteriorLabel.attributedText = NSAttributedString(string: "$ " + producto.original_price.formatted(.number), attributes: atributoTachado)
                precioAnteriorLabel.isHidden = false
            }
            else{
                precioAnteriorLabel.text = ""
                precioAnteriorLabel.isHidden = true
            }
            
            precioActualLabel.text = "$ " + producto.price.formatted(.number)
            productoImageView.image = UIImage(named: "no-image") // Imagen por defecto mientras carga
            
            if let url = URL(string: producto.thumbnail) {
                loadImage(from: url) { image in
                    DispatchQueue.main.async {
                        self.productoImageView.image = image
                    }
                }
            }
            vendedorLabel.text = "Vendedor: " + producto.seller
            atributosTableView.reloadData()
        }
        else{
            LogHelper.shared.logError("No llego correctament el producto en ProductoDetalleViewController")
            mostrarDialogo(en: self, mensaje: "Ups, parece que hubo un error intenta de nuevo")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProductoDetalleViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return producto?.attributes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AtributoCell", for: indexPath) as! AtributoTableViewCell
        if let atributo = producto?.attributes[indexPath.row] {
            cell.tituloLabel.text = atributo.name
            cell.descripcionLabel.text = atributo.value_name
        }
        else{
            cell.tituloLabel.text = ""
            cell.descripcionLabel.text = ""
        }
        
        
        return cell
    }
    
    
}
