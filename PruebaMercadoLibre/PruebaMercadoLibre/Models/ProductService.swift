//
//  ProductoService.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 26/02/25.
//

import Foundation

class ProductService {
    static let shared = ProductService() //Unica instancia de ProductService
    
    //Inicializacion privada para utilizar patron singleton
    private init() {}

    func consultarProductos(productoBuscado: String, currentOffset: Int, completion: @escaping (Result<respuestaProducto, Error>) -> Void) {
        let urlString = "https://api.mercadolibre.com/sites/MLA/search?q=\(productoBuscado)&offset=\(currentOffset)"
        
        //En caso de que la url este mal formada o no responda se responde con mensaje de error
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Error al consultar la URL", code: 400, userInfo: nil)))
            return
        }
        
        //Se consulta el API
        URLSession.shared.dataTask(with: url) { data, response, error in
            //En caso de error informarlo
            if let error = error {
                completion(.failure(error))
                return
            }
            //En caso de no tener datos que mostrar informar el error
            guard let data = data else {
                completion(.failure(NSError(domain: "Error no se encontro información disponible", code: 500, userInfo: nil)))
                return
            }
            
            do {
                var productos :[Producto] = []
                var total = 0
                var limit = 0
                //Convertir json a respuestaProducto
                //Se toman solo los campos necesarios
                if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    if let paging = jsonObject["paging"] as? [String: Int] {
                        total = paging["total"] ?? 0
                        limit = paging["limit"] ?? 0
                    }
                    
                    if let results = jsonObject["results"] as? [[String:Any]] {
                        results.forEach{ item_p in
                            var discount :Double = 0.0
                            if let sales_price = item_p["sale_price"] as? [String:Any], let sales_price_type = sales_price["type"] as? String, sales_price_type == "promotion", let sales_price_metadata = sales_price["metadata"] as? [String:Any] {
                                
                                discount = sales_price_metadata["campaign_discount_percentage"] as? Double ?? 0.0
                            }
                            var atributos :[Atributos] = []
                            if let attributes = item_p["attributes"] as? [[String:Any]] {
                                attributes.forEach{ item_a in
                                    if let name_a = item_a["name"] as? String, let value_a = item_a["value_name"] as? String{
                                        atributos.append(Atributos(name: name_a, value_name: value_a))
                                    }
                                }
                                
                            }
                            
                            productos.append(Producto(id: item_p["id"] as? String ?? "",
                               title: item_p["title"] as? String ?? "",
                               permalink: item_p["permalink"] as? String ?? "",
                               thumbnail: item_p["thumbnail"] as? String ?? "",
                               currency_id: item_p["currency_id"] as? String ?? "",
                               price: item_p["price"] as? Double ?? 0,
                               original_price: item_p["original_price"] as? Double ?? 0,
                               discount_percentage: discount,
                               seller: item_p["id"] as? String ?? "",
                               attributes: atributos
                             ))
                        }
                        
                    }
                }
                //Se informa que se completo satisfactoriamente la consulta de productos
                DispatchQueue.main.async {
                    completion(.success(respuestaProducto(productos: productos, total: total, limit: limit)))
                }
            } catch {
                LogHelper.shared.logError("Error en ProductService.consultarProductos: \(error.localizedDescription)")

                completion(.failure(error))
            }
        }.resume()
    }
}
