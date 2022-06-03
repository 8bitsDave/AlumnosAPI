//
//  File.swift
//  
//
//  Created by David Novella Giménez on 3/6/22.
//

import Vapor
import Fluent

extension FieldKey {
    static let direccion = FieldKey("direccion")
    static let contacto = FieldKey("contacto")
    static let nombre = FieldKey("nombre")
    static let apellidos = FieldKey("apellidos")
    static let nacimiento = FieldKey("nacimiento")
    static let empresa = FieldKey("empresa")
    static let nivel = FieldKey("nivel")
    static let duracion = FieldKey("duracion")
    static let fechaInicio = FieldKey("fecha_inicio")
    static let alumnoID = FieldKey("alumno")
    static let formacionID = FieldKey("formacion")
}
