//
//  ConfigViewController.swift
//  gestorLibros
//
//  Created by user152673 on 11/5/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteAll(_ sender: UIButton) {
        let alert = UIAlertController(title: "¿Estás seguro de que quieres borrar todo?", message: "Todos tus libros seran borrados sin posibilidad de ser recuperados", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler: {action in
            
            //books.removeAll()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func loadSampleBooks() {
        
        let photo1 = UIImage(named: "book1")
        let photo2 = UIImage(named: "book2")
        let photo3 = UIImage(named: "book3")
        
        guard let book1 = Book(nombre: "Los Juegos del Hambre", portada: photo1, puntuacion: 4, autor: "Suzanne Collins", genero: "Literatura Juvenil", favorito: true) else {
            fatalError("Unable to instantiate book1")
        }
        
        guard let book2 = Book(nombre: "Invisible", portada: photo2, puntuacion: 5, autor: "Eloy Moreno", genero: "Literatura Juvenil", favorito: true) else {
            fatalError("Unable to instantiate book2")
        }
        
        guard let book3 = Book(nombre: "Tierra", portada: photo3, puntuacion: 3, autor: "Eloy Moreno", genero: "Ficcion", favorito: false) else {
            fatalError("Unable to instantiate book3")
        }
        
        books += [book1, book2, book3]
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
