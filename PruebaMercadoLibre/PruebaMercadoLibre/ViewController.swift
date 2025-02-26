//
//  ViewController.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 25/02/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension UIViewController{
    
    func mostrarDialogo(en vista: UIViewController, mensaje: String) {
        let alerta = UIAlertController(title: "Aviso", message: mensaje, preferredStyle: .alert)
        let aceptarAccion = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alerta.addAction(aceptarAccion)
        vista.present(alerta, animated: true, completion: nil)
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let urlString = url.absoluteString as NSString
        
        // 1. Verificar si la imagen ya está en caché
        if let cachedImage = ImageCache.shared.object(forKey: urlString) {
            completion(cachedImage)
            return
        }
        
        // 2. Si no está en caché, descargarla
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }
            
            // 3. Guardarla en caché antes de devolverla
            ImageCache.shared.setObject(image, forKey: urlString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
