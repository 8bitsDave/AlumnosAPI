//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

struct AlumnoController:RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let app = routes.grouped("api")
        app.group("alumnos") { alumno in
            alumno.get(use: getAlumnos)
        }
        
        app.group("empresas") { empresa in
            empresa.get(use: getEmpresas)
        }
    }
    
    func getAlumnos(req:Request) async throws -> Alumno {
        try await Alumno
            .query(on: req.db)
            .with(\.$empresa)
            .all()
    }
    
    
    func getEmpresas(req:Request) async throws -> Empresa {
        try await Empresa
            .query(on: req.db)
            .all()
    }
    
}
