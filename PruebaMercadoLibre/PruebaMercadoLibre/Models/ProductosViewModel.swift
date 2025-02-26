//
//  ProductsViewModel.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 26/02/25.
//

import Foundation

class ProductosViewModel {
    
    private let productService = ProductService.shared
    var productos: [Producto] = []
    
    var onProductosActualizados: (() -> Void)?
    var onError: ((String) -> Void)?
    
    var estaCargando = false
    var offsetActual = 0
   
    
    func cargarProductos(productoBuscado: String) {
        //Se evita las multiples consultas cuando aun este cargando la consulta al API
        guard !estaCargando else { return }
        
        estaCargando = true
        //se consulta al API
        productService.consultarProductos(productoBuscado: productoBuscado, currentOffset: offsetActual) { [weak self] result in
            guard let self = self else { return }
            
            
            switch result {
            case .success(let response):
                //Se agregan los nuevos productos a los que se tenian anteriormente
                self.productos.append(contentsOf: response.productos)
                //Se verifica que aun hayan productos disponibles con la consulta realizada
                if(response.total > self.offsetActual){
                    self.offsetActual += response.limit
                    self.estaCargando = false
                }
                //Se informa que los productos han sido actualizados
                self.onProductosActualizados?()
                
            case .failure(let error):
                LogHelper.shared.logError("Error en ProductosViewModel.cargarProductos: \(error.localizedDescription)")
                //Se informa que hubo un error y envia el mensaje de error
                self.onError?("Hubo un error al cargar los productos")
            }
        }
    }
}
