//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

final class Nivel:Model, Codable {
    static let schema = "niveles"
    
    @ID(key: .id) var id: UUID?
    @Field(key: .nombre) var nombre:String
    
    @Children(for: \.$nivel) var formacionesNivel:[Formacion]
    
    init() {}
    
    init(id:UUID? = nil, nombre:String) {
        self.id = id
        self.nombre = nombre
    }
}
