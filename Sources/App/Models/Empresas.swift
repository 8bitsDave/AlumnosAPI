//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

typealias Empresas = [Empresa]

final class Empresa:Model, Content {
    static let schema = "empresas"
    
    @ID(key: .id) var id:UUID?
    @Field(key: .nombre) var nombre:String
    @Field(key: .direccion) var direccion:String
    @Field(key: .contacto) var contacto:String
    
    @Children(for: \.$empresa) var alumnosEmpresa:[Alumno]
    
    init() {}
    
    init(id:UUID? = nil, nombre:String, direccion:String, contacto:String) {
        self.id = id
        self.nombre = nombre
        self.direccion = direccion
        self.contacto = contacto
    }
}

struct CreateEmpresa:Content {
    let nombre:String
    let direccion:String
    let contacto:String
}

struct UpdateEmpresa:Content {
    let nombre:String?
    let direccion:String?
    let contacto:String?
}
