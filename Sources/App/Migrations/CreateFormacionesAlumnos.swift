//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

struct CreateFormacionesAlumnos:AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(FormacionAlumno.schema)
            .id()
            .field(.alumnoID, .int, .required)
            .field(.formacionID, .uuid, .required)
            .unique(on: .alumnoID, .formacionID)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(FormacionAlumno.schema)
            .delete()
    }
}


