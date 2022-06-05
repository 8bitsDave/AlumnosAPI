//
//  File.swift
//  
//
//  Created by David Novella Giménez on 4/6/22.
//

import Vapor
import Fluent

struct NivelesController:RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let app = routes.grouped("api")
        app.group("niveles") { niveles in
            niveles.get(use: readNiveles)
            niveles.post(use: createNivel)
            niveles.group(":nivelID") { nivel in
                nivel.get(use: readNivel)
                nivel.patch(use: updateNivel)
                nivel.delete(use: deleteNivel)
            }
        }
    }

    func createNivel(req:Request) async throws -> Nivel {
      let content = try req.content.decode(CreateNivel.self)
      if try await Nivel
          .query(on: req.db)
          .filter(\.$nombre, .custom("ILIKE"), content.nombre)
          .all()
          .count == 0 {
          let newNivel = Nivel(nombre: content.nombre.capitalized)
          try await newNivel.create(on: req.db)
          return newNivel
      } else {
          throw Abort(.badRequest, reason: "Ya existe el nivel: \(content.nombre)")
      }
    }

    func readNiveles(req:Request) async throws -> Niveles {
      try await Nivel
          .query(on: req.db)
          .all()
    }

    func readNivel(req:Request) async throws -> Nivel {
      guard let id = req.parameters.get("nivelID", as: UUID.self) else { throw Abort(.badRequest) }
      guard let nivel = try await Nivel.find(id, on: req.db) else { throw Abort(.notFound) }
      return nivel
    }

    func updateNivel(req:Request) async throws -> Response {
        let content = try req.content.decode(CreateNivel.self)
        guard let id = req.parameters.get("nivelID", as: UUID.self) else { throw Abort(.badRequest) }
        guard let nivel = try await Nivel.find(id, on: req.db) else { throw Abort(.notFound) }
        if content.nombre.lowercased() != nivel.nombre.lowercased() {
            nivel.nombre = content.nombre.capitalized
            try await nivel.update(on: req.db)
            return Response(status: .ok)
        } else {
            throw Abort(.badRequest, reason: "El nivel ya se llama así")
        }
    }

    func deleteNivel(req:Request) async throws -> Response {
        guard let id = req.parameters.get("nivelID", as: UUID.self) else { throw Abort(.badRequest) }
        if let nivel = try await Nivel.find(id, on: req.db) {
            try await nivel.delete(on: req.db)
            return Response(status: .ok)
        } else {
            throw Abort(.notFound)
        }
    }
}
    
