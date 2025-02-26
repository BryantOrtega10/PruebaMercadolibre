//
//  BusquedaViewController.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 25/02/25.
//

import UIKit

class BusquedaViewController: UIViewController {
    
    var contenedorLogoView = LogoMercadoLibreView()
    var contenedorBusquedaView = BusquedaView()
    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []
    var productoBuscado: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contenedorBusquedaView.delegate = self
        
        self.view.addSubview(contenedorLogoView)
        self.view.addSubview(contenedorBusquedaView)
        
        //Funcionalidad para ocultar el teclado al hacer tap fuera del searchbar
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ocultarTeclado))
        view.addGestureRecognizer(tapGesture)
        
        setupContraints()
        // Do any additional setup after loading the view.
    }
    
    //Actualizar las constraints cuando se cambia de posicion
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        NSLayoutConstraint.deactivate(portraitConstraints + landscapeConstraints)
        if size.width > size.height {
            NSLayoutConstraint.activate(landscapeConstraints)
        } else {
            NSLayoutConstraint.activate(portraitConstraints)
        }
        view.layoutIfNeeded()
    }
        
    
    func setupContraints(){
        
        //Se agregan las constraints que no van a cambiar cuando la orientación del dispositivo cambie
        NSLayoutConstraint.activate([
            contenedorLogoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            contenedorLogoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contenedorBusquedaView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            contenedorBusquedaView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        //Se declaran pero no se agregan las constraints las constraints que dependen de la orientacion del dispositivo
        portraitConstraints = [
            contenedorLogoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            contenedorLogoView.bottomAnchor.constraint(equalTo: contenedorBusquedaView.topAnchor, constant: 0),
            contenedorBusquedaView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contenedorBusquedaView.topAnchor.constraint(equalTo: contenedorLogoView.bottomAnchor, constant: 0),
            contenedorLogoView.heightAnchor.constraint(equalTo: contenedorBusquedaView.heightAnchor, multiplier: 0.65),
        ]
        
        landscapeConstraints = [
            contenedorLogoView.trailingAnchor.constraint(equalTo: contenedorBusquedaView.leadingAnchor, constant: 0),
            contenedorLogoView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            contenedorBusquedaView.leadingAnchor.constraint(equalTo: contenedorLogoView.trailingAnchor, constant: 0),
            contenedorBusquedaView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            contenedorLogoView.widthAnchor.constraint(equalTo: contenedorBusquedaView.widthAnchor, multiplier: 0.65),
        ]
        
        
        //Se agregan constraints dependiendo de la orientacion actual del dispositivo
        var orientacionInicial = "portrait"
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene{
            let orientation = scene.interfaceOrientation
            if orientation.isLandscape {
                orientacionInicial = "landscape"
            }
        }
        if orientacionInicial == "portrait"{
            NSLayoutConstraint.activate(portraitConstraints)
        }
        else{
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
    
    //Ocultar el teclado
    @objc private func ocultarTeclado() {
        contenedorBusquedaView.busquedaSearchBar.resignFirstResponder()
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
//Implementación de BusquedaViewDelegate para gestionar cuando se da click en el boton de buscar
extension BusquedaViewController: BusquedaViewDelegate{
    func didTapBuscarButton(with textoBuscado: String?) {
        //Validar que el texto buscado no sea vacio
        if(textoBuscado != ""){
            productoBuscado = textoBuscado
            contenedorBusquedaView.busquedaSearchBar.resignFirstResponder()
            performSegue(withIdentifier: "mostrarProducto", sender: self)
        }
        else{
            LogHelper.shared.logInfo("El usuario intento continuar sin diligenciar ningun texto en BusquedaViewController")
            mostrarDialogo(en: self, mensaje: "Campo de busqueda vacio. Escribe algo para continuar")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarProducto",
           let destino = segue.destination as? ListaProductosViewController {
            //Envia el productoBuscado a ProductsViewController
            destino.productoRecibido = productoBuscado
        }
    }
}
