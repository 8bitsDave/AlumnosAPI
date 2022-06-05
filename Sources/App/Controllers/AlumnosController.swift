//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

struct AlumnosController:RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let app = routes.grouped("api")
        app.group("alumnos") { alumnos in
            alumnos.get(use: readAlumnos)
            alumnos.post(use: createAlumno)
            alumnos.group(":alumnoID") { alumno in
                alumno.get(use: readAlumno)
                alumno.patch(use: updateAlumno)
                alumno.delete(use: deleteAlumno)
            }
        }
    }
    
    func createAlumno(req:Request) async throws -> Alumno {
        let content = try req.content.decode(CreateAlumno.self)

        if let empresaID = content.empresa {
            guard let _ = try await Empresa.find(empresaID, on: req.db) else {
            throw Abort(.badRequest, reason: "La empresa introducida no existe")
            }
        }
        if try await Alumno
            .query(on: req.db)
            .filter(\.$nombre, .custom("ILIKE"), content.nombre)
            .filter(\.$apellidos, .custom("ILIKE"), content.apellidos)
            .all()
            .count == 0 {
            let newAlumno = Alumno(nombre: content.nombre.capitalized,
                                   apellidos: content.apellidos.capitalized,
                                   nacimiento: content.nacimiento ?? nil,
                                   empresa: content.empresa ?? nil)
            try await newAlumno.create(on: req.db)
            return newAlumno
        } else {
            throw Abort(.badRequest, reason: "Ya existe el alumno: \(content.nombre) \(content.apellidos)")
        }
    }

    func readAlumnos(req:Request) async throws -> Alumnos {
        try await Alumno
            .query(on: req.db)
            .with(\.$empresa)
            .all()
    }
    
    func readAlumno(req:Request) async throws -> Alumno {
        guard let id = req.parameters.get("alumnoID", as: Int.self) else { throw Abort(.badRequest) }
        if let alumno = try await Alumno.find(id, on: req.db) {
            try await alumno.$empresa.load(on: req.db)
            return alumno
        } else {
            throw Abort(.notFound)
        }
    }
    
    func updateAlumno(req:Request) async throws -> Response {
        let content = try req.content.decode(UpdateAlumno.self)
        guard let id = req.parameters.get("alumnoID", as: Int.self) else { throw Abort(.badRequest) }
        guard let alumno = try await Alumno.find(id, on: req.db) else { throw Abort(.notFound) }
        if let nombre = content.nombre, nombre != alumno.nombre {
            alumno.nombre = nombre
        }
        if let apellidos = content.apellidos, apellidos != alumno.apellidos {
            alumno.apellidos = apellidos
        }
        if let nacimiento = content.nacimiento, nacimiento != alumno.nacimiento {
            alumno.nacimiento = nacimiento
        }
        if let empresa = content.empresa, empresa != alumno.$empresa.id {
            guard try await Empresa.find(empresa, on: req.db) != nil else {
                throw Abort(.notFound, reason: "Empresa no encontrada.")
            }
            alumno.$empresa.id = empresa
        }
        try await alumno.update(on: req.db)
        return Response(status: .ok)
    }

    func deleteAlumno(req:Request) async throws -> Response {
        guard let id = req.parameters.get("alumnoID", as: Int.self) else { throw Abort(.badRequest) }
        if let alumno = try await Alumno.find(id, on: req.db) {
            try await alumno.delete(on: req.db)
            return Response(status: .ok)
        } else {
            throw Abort(.notFound)
        }
    }

}
