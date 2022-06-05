//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

struct CreateEmpresas:AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Empresa.schema)
            .id()
            .field(.nombre, .string, .required)
            .field(.direccion, .string, .required)
            .field(.contacto, .string, .required)
            .unique(on: .nombre)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Empresa.schema)
            .delete()
    }
}

