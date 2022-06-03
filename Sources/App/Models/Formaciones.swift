//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

final class Formacion:Model, Content {
    static let schema = "formaciones"
    
    @ID(key: .id) var id:UUID?
    @Field(key: .nombre) var nombre:String
    @Parent(key: .nivel) var nivel:Nivel
    @Field(key: .duracion) var duracion:Int
    @Field(key: .fechaInicio) var fechaInicio:Date

    init() {}
    
    init(id:UUID? = nil, nombre:String, nivel:UUID, duracion:Int, fechaInicio:Date) {
        self.id = id
        self.nombre = nombre
        self.$nivel.id = nivel
        self.duracion = duracion
        self.fechaInicio = fechaInicio
    }
}

//extension Formacion:Validatable  // para marcar validaciones a la inserción de formaciones
