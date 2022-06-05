//
//  File.swift
//  
//
//  Created by David Novella Giménez on 4/6/22.
//

import Vapor
import Fluent

struct FormacionesController:RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let app = routes.grouped("api")
        app.group("formaciones") { formaciones in
//            formaciones.get(use: readFormaciones)
//            formaciones.post(use: createFormacion)
//            formaciones.group(":alumnoID") { formacion in
//                formaciones.get(use: readFormacion)
//            }
        }
    }
}
