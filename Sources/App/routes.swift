import Fluent
import Vapor

func routes(_ app: Application) throws {

    try app.register(collection: AlumnosController())
    try app.register(collection: EmpresasController())
    try app.register(collection: FormacionesController())
    try app.register(collection: NivelesController())
    
}
