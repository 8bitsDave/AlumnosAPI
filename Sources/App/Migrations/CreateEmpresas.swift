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
            .field(.direccion, .string, .required)
            .field(.contacto, .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Empresa.schema)
            .delete()
    }
}

