//
//  LogoMercadoLibreView.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 25/02/25.
//
import UIKit

class LogoMercadoLibreView: UIView{
    
    var logoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        //Color Amarillo
        backgroundColor = UIColor(red: (255/255), green: (230/255), blue: (1/255), alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        
        
        logoImageView.image = UIImage(named: "MercadoLibreLogo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            logoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
    }
    
}
