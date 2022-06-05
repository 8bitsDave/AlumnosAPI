//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

typealias Niveles = [Nivel]

final class Nivel:Model, Content {
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

struct CreateNivel:Content {
    let nombre:String
}
