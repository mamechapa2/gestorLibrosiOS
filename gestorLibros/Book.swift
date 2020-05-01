//
//  Meal.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log


class Book: NSObject, NSCoding {
    
    //MARK: Properties
    
    var nombre: String
    var portada: UIImage?
    var puntuacion: Int
    var autor: String
    var genero: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    
    struct PropertyKey {
        static let nombre = "nombre"
        static let portada = "portada"
        static let puntuacion = "puntuacion"
        static let autor = "autor"
        static let genero = "genero"
    }
    
    //MARK: Initialization
    
    init?(nombre: String, portada: UIImage?, puntuacion: Int, autor: String, genero: String) {
        
        // The name must not be empty
        guard !nombre.isEmpty else {
            return nil
        }

        // The rating must be between 0 and 5 inclusively
        guard (puntuacion >= 0) && (puntuacion <= 5) else {
            return nil
        }
        
        // Initialization should fail if there is no name or if the rating is negative.
        if nombre.isEmpty || puntuacion < 0  {
            return nil
        }
        
        guard !autor.isEmpty else {
            return nil
        }
        
        guard !genero.isEmpty else {
            return nil
        }
        
        // Initialize stored properties.
        self.nombre = nombre
        self.portada = portada
        self.puntuacion = puntuacion
        self.autor = autor
        self.genero = genero
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nombre, forKey: PropertyKey.nombre)
        aCoder.encode(portada, forKey: PropertyKey.portada)
        aCoder.encode(puntuacion, forKey: PropertyKey.puntuacion)
        aCoder.encode(autor, forKey: PropertyKey.autor)
        aCoder.encode(genero, forKey: PropertyKey.genero)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let nombre = aDecoder.decodeObject(forKey: PropertyKey.nombre) as? String else {
            os_log("Unable to decode the name for a book object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let portada = aDecoder.decodeObject(forKey: PropertyKey.portada) as? UIImage
        
        let puntuacion = aDecoder.decodeInteger(forKey: PropertyKey.puntuacion)
        
        guard let autor = aDecoder.decodeObject(forKey: PropertyKey.autor) as? String else {
            os_log("Unable to decode the name for a book object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let genero = aDecoder.decodeObject(forKey: PropertyKey.genero) as? String else {
            os_log("Unable to decode the name for a book object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(nombre: nombre, portada: portada, puntuacion: puntuacion, autor: autor, genero: genero)
        
    }
}
