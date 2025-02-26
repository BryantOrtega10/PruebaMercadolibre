//
//  LogHelper.swift
//  PruebaMercadoLibre
//
//  Created by Bryant Ortega on 26/02/25.
//

import os

class LogHelper {
    static let shared = LogHelper()
    private let logger = Logger(subsystem: "com.bryant.ortega.PruebaMercadoLibre", category: "Networking")

    func logError(_ message: String) {
        logger.error("\(message)")
    }
    
    func logInfo(_ message: String) {
        logger.info("\(message)")
    }
    
    func logDebug(_ message: String) {
        logger.debug("\(message)")
    }
}
