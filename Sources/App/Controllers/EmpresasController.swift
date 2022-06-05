//
//  File.swift
//  
//
//  Created by David Novella Giménez on 4/6/22.
//

import Vapor
import Fluent

struct EmpresasController:RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let app = routes.grouped("api")

        app.group("empresas") { empresas in
            empresas.get(use: readEmpresas)
            empresas.post(use: createEmpresa)
            empresas.group(":empresaID") { empresa in
                empresa.get(use: readEmpresa)
                empresa.patch(use: updateEmpresa)
                empresa.delete(use: deleteEmpresa)
            }
        }
    }
  
    func createEmpresa(req:Request) async throws -> Empresa {
        let content = try req.content.decode(CreateEmpresa.self)
        if try await Empresa
            .query(on: req.db)
            .filter(\.$nombre, .custom("ILIKE"), content.nombre)
            .all()
            .count == 0 {
            let newEmpresa = Empresa(nombre: content.nombre.capitalized, direccion: content.direccion.capitalized, contacto: content.contacto.capitalized)
            try await newEmpresa.create(on: req.db)
            return newEmpresa
        } else {
            throw Abort(.badRequest, reason: "Ya existe la empresa: \(content.nombre)")
        }
    }
    
    func readEmpresas(req:Request) async throws -> Empresas {
        try await Empresa
            .query(on: req.db)
            .all()
    }
    
    func readEmpresa(req:Request) async throws -> Empresa {
        guard let id = req.parameters.get("empresaID", as: UUID.self) else { throw Abort(.badRequest) }
        guard let empresa = try await Empresa.find(id, on: req.db) else { throw Abort(.notFound, reason: "No encuentro la empresa") }
        return empresa
    }

    
    func updateEmpresa(req:Request) async throws -> Response {
        let content = try req.content.decode(UpdateEmpresa.self)
        guard let id = req.parameters.get("empresaID", as: UUID.self) else { throw Abort(.badRequest) }
        guard let empresa = try await Empresa.find(id, on: req.db) else { throw Abort(.notFound) }
        if let nombre = content.nombre, nombre != empresa.nombre {
            empresa.nombre = nombre
        }
        if let direccion = content.direccion, direccion != empresa.direccion {
            empresa.direccion = direccion
        }
        if let contacto = content.contacto, contacto != empresa.contacto {
            empresa.contacto = contacto
        }
        try await empresa.update(on: req.db)
        return Response(status: .ok)
    }

    func deleteEmpresa(req:Request) async throws -> Response {
        guard let id = req.parameters.get("empresaID", as: UUID.self) else { throw Abort(.badRequest) }
        if let empresa = try await Empresa.find(id, on: req.db) {
            try await empresa.delete(on: req.db)
            return Response(status: .ok)
        } else {
            throw Abort(.notFound)
        }
    }
    
}
