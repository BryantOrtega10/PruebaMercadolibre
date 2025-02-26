//
//  ListaProductosViewController.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 25/02/25.
//

import UIKit

class ListaProductosViewController: UIViewController {

    var productoRecibido: String?
    var activityIndicator: UIActivityIndicatorView!
    let productosViewModel = ProductosViewModel()
    
  
    @IBOutlet weak var productosTableView: UITableView!
    @IBOutlet weak var busquedaLabel: UILabel!
    @IBOutlet weak var noProductView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        consultarProductos()
        // Do any additional setup after loading the view.
    }
    
    func consultarProductos(){        
        //Actualizar views cuando los productos se actualicen en el view model
        productosViewModel.onProductosActualizados = { [weak self] in
            guard let self = self else { return }
            if(productosViewModel.productos.count > 0){
                productosTableView.isHidden = false
                noProductView.isHidden = true
            }
            else{
                productosTableView.isHidden = true
                noProductView.isHidden = false
            }
            self.ocultarCargando()
            self.productosTableView.reloadData()
        }
        //Mostrar errores que provengan del servicio o el view model
        productosViewModel.onError = { [weak self] message in
            guard let self = self else { return }
            self.ocultarCargando()
            self.mostrarDialogo(en: self, mensaje: message)
        }
        //Llamado a cargar productos segun la busqueda recibida
        mostrarCargando()
        productosViewModel.cargarProductos(productoBuscado: productoRecibido ?? "")
        
    }
    
    func setupView(){
        productosTableView.delegate = self
        productosTableView.dataSource = self
        busquedaLabel.text = "Buscando: " + (productoRecibido ?? "")
        
        productosTableView.isHidden = true
        noProductView.isHidden = true
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
    }
    
    func mostrarCargando() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false // Bloquea la interacción mientras carga
    }
    
    func ocultarCargando() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true // Vuelve a habilitar la interacción
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
extension ListaProductosViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Obtiene el producto desde sender
        if segue.identifier == "mostrarDetalleProducto",
           let detalleVC = segue.destination as? ProductoDetalleViewController,
           let producto = sender as? Producto {
            //Envia producto seleccionado a ProductoDetalleViewController
            detalleVC.producto = producto
        }
    }
}

extension ListaProductosViewController: UITableViewDelegate, UITableViewDataSource{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        // Cuando el usuario está a 200px del final vuelve a realizar la consulta de productos
        if position > contentHeight - frameHeight - 200 {
            productosViewModel.cargarProductos(productoBuscado: productoRecibido ?? "")
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Se deselecciona la fila evitando que continue seleccionada mientras muestra el detalle del producto
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Asigna el producto seleccionado al sender de la segue
        let productoSeleccionado = productosViewModel.productos[indexPath.row]
        performSegue(withIdentifier: "mostrarDetalleProducto", sender: productoSeleccionado)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productosViewModel.productos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductsTableViewCell
        
        //Obtiene el producto actual de la fila
        let producto = productosViewModel.productos[indexPath.row]

        //Cambia la vista de la celda segun el producto actual
        cell.nombreLabel.text = producto.title
        if(producto.discount_percentage > 0){
            cell.porcentajeDescuentoLabel.text = producto.discount_percentage.formatted(.number) + "%"
            cell.porcentajeDescuentoLabel.isHidden = false
        }
        else{
            cell.porcentajeDescuentoLabel.text = ""
            cell.porcentajeDescuentoLabel.isHidden = true
        }
        
        if(producto.original_price > 0){
            cell.precioAnteriorLabel.attributedText = NSAttributedString(string: "$ " + producto.original_price.formatted(.number), attributes: cell.atributoTachado)
            cell.precioAnteriorLabel.isHidden = false
        }
        else{
            cell.precioAnteriorLabel.text = ""
            cell.precioAnteriorLabel.isHidden = true
        }
        
        cell.precioActualLabel.text = "$ " + producto.price.formatted(.number)
        cell.productoImageView.image = UIImage(named: "no-image") // Imagen por defecto mientras carga
        
        if let url = URL(string: producto.thumbnail) {
            loadImage(from: url) { image in
                DispatchQueue.main.async {
                    if tableView.indexPath(for: cell) == indexPath { // Evitar imágenes incorrectas por reutilización de celdas
                        cell.productoImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
}
