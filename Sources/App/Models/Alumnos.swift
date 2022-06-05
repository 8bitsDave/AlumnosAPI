//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

typealias Alumnos = [Alumno]

final class Alumno:Model, Content {
    static let schema = "alumnos"
    
    @ID(custom: .id) var id:Int?
    @Field(key: .nombre) var nombre:String
    @Field(key: .apellidos) var apellidos:String
    @Field(key: .nacimiento) var nacimiento:Date?
    @OptionalParent(key: .empresa) var empresa:Empresa?

    init() {}
    
    init(id:Int? = nil, nombre:String, apellidos:String, nacimiento:Date?, empresa:UUID?) {
        self.id = id
        self.nombre = nombre
        self.apellidos = apellidos
        self.nacimiento = nacimiento
        self.$empresa.id = empresa
    }
}

struct CreateAlumno:Content {
    let nombre:String
    let apellidos:String
    let nacimiento:Date?
    let empresa:UUID?
}

struct UpdateAlumno:Content {
    let nombre:String?
    let apellidos:String?
    let nacimiento:Date?
    let empresa:UUID?
}
