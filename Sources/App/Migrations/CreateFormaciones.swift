//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

struct CreateFormaciones:AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Formacion.schema)
            .id()
            .field(.nombre, .string, .required)
            .field(.nivel, .uuid, .references(Nivel.schema, .id, onDelete: .setNull), .required)
            .field(.duracion, .int, .required)
            .field(.fechaInicio, .date, .required)
            .unique(on: .nombre)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Formacion.schema)
            .delete()
    }
}

