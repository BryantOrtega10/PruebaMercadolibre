//
//  BusquedaView.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 25/02/25.
//

import UIKit

class BusquedaView: UIView {
    
    weak var delegate: BusquedaViewDelegate?
    var busquedaLabel :UILabel!
    var busquedaSearchBar :UISearchBar!
    var busquedaButton :UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        busquedaLabel = UILabel()
        busquedaLabel.text = "¡Busca lo que necesites!"
        busquedaLabel.font = UIFont(name: "system", size: 24.0)
        busquedaLabel.translatesAutoresizingMaskIntoConstraints = false
        
        busquedaSearchBar = UISearchBar()
        busquedaSearchBar.searchBarStyle = .minimal
        busquedaSearchBar.placeholder = "¿Qué estás buscando?"
        busquedaSearchBar.translatesAutoresizingMaskIntoConstraints = false
        busquedaSearchBar.delegate = self
        
        
        busquedaButton = UIButton()
        busquedaButton.setTitle("Buscar", for: .normal)
        busquedaButton.setTitleColor(.white, for: .normal)
        busquedaButton.backgroundColor = .systemBlue
        busquedaButton.translatesAutoresizingMaskIntoConstraints = false
        busquedaButton.layer.cornerRadius = 8
        busquedaButton.addTarget(self, action: #selector(buscarButtonTapped), for: .touchUpInside)
        
        addSubview(busquedaLabel)
        addSubview(busquedaSearchBar)
        addSubview(busquedaButton)
        
        NSLayoutConstraint.activate([
            busquedaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            busquedaLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            busquedaSearchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            busquedaSearchBar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            busquedaSearchBar.topAnchor.constraint(equalTo: busquedaLabel.bottomAnchor, constant: 16),
            busquedaSearchBar.heightAnchor.constraint(equalToConstant: 56),
            busquedaButton.topAnchor.constraint(equalTo: busquedaSearchBar.bottomAnchor, constant: 16),
            busquedaButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            busquedaButton.heightAnchor.constraint(equalToConstant: 32),
            busquedaButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    
    
    @objc private func buscarButtonTapped() {
        delegate?.didTapBuscarButton(with: busquedaSearchBar.text)
    }
    
}

extension BusquedaView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.didTapBuscarButton(with: busquedaSearchBar.text)
        searchBar.resignFirstResponder() // Oculta el teclado cuando se presiona "Buscar"
    }
}
