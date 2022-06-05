//
//  File.swift
//  
//
//  Created by Julio César Fernández Muñoz on 1/6/22.
//

import Foundation
import Vapor

extension DateFormatter {
    static let formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}

func decode<T:Content>(req:Request, type:T.Type) throws -> T {
    do {
        return try req.content.decode(type)
    } catch {
        throw Abort(.badRequest, reason: "JSON de entrada no válido")
    }
}
