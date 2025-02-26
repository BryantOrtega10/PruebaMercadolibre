//
//  Producto.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 25/02/25.
//


struct Atributos: Decodable {
    let name: String
    let value_name: String
}

struct Producto: Decodable {
    let id: String
    let title: String
    let permalink: String
    let thumbnail: String
    let currency_id: String
    let price: Double
    let original_price: Double
    let discount_percentage: Double
    let seller: String
    let attributes: [Atributos]
}

struct respuestaProducto: Decodable{
    let productos: [Producto]
    let total: Int
    let limit: Int
}
