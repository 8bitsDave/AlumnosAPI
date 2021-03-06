import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    if let databaseURL = Environment.get("DATABASE_URL") {
        try app.databases.use(.postgres(url: databaseURL), as: .psql)
    } else {
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database"
        ), as: .psql)
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.formatter)
    ContentConfiguration.global.use(decoder: decoder, for: .json)
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(.formatter)
    ContentConfiguration.global.use(encoder: encoder, for: .json)
    
    app.migrations.add(CreateEmpresas())
    app.migrations.add(CreateAlumnos())
    app.migrations.add(CreateNiveles())
    app.migrations.add(CreateFormaciones())
    app.migrations.add(CreateFormacionesAlumnos())

    app.views.use(.leaf)

    

    // register routes
    try routes(app)
}
