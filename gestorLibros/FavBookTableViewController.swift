//
//  FavBookTableViewController.swift
//  gestorLibros
//
//  Created by user152673 on 5/5/20.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
//Controlador para la vista de los libros favoritos
class FavBookTableViewController: UITableViewController {
    
    var favBooks = [Book]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //Cuando carga la vista, hay que cargar los libros favoritos
        reloadFavBooks()

    }
    //Si nos da por volver a la vista, habría que recargar los libros, podrían haber cambiado
    override func viewWillAppear(_ animated: Bool) {
        reloadFavBooks()
    }
    //Muestra los libros favoritos
    func reloadFavBooks(){
        //Primero los quitmos
        favBooks.removeAll()
        //Por cada libro
        for book in books {
            //Si es favorito, añádelo a la colección
            if(book.favorito){
                favBooks.append(book)
            }
        }
        
        tableView.reloadData()
    }

    // MARK: - Métodos de la tabla

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Número de elementos
        return favBooks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Cada celda tiene un identificador.
        let cellIdentifier = "FavBookTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FavBookTableViewCell else {
                fatalError("The dequeued cell is not an instance of FavBookTableViewCell.")
        
        }
        //Configurar la celda de la tabla
        let book = favBooks[indexPath.row]
        
        cell.nombreFav.text = book.nombre
        cell.imageFav.image = book.portada
        cell.ratingControlFav.rating = book.puntuacion

        // Carga la celda

        return cell
    }
}
