//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class BookTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var books = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedBooks = loadBooks() {
            books += savedBooks
        }
        else {
            // Load the sample data.
            loadSampleBooks()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BookTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BookTableViewCell  else {
            fatalError("The dequeued cell is not an instance of BookTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let book = books[indexPath.row]
        
        cell.nameLabel.text = book.nombre
        cell.photoImageView.image = book.portada
        cell.ratingControl.rating = book.puntuacion
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            books.remove(at: indexPath.row)
            saveBooks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new book.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let bookDetailViewController = segue.destination as? BookViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedBookCell = sender as? BookTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedBookCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedBook = books[indexPath.row]
            bookDetailViewController.book = selectedBook
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }

    
    //MARK: Actions
    
    @IBAction func unwindToBookList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? BookViewController, let book = sourceViewController.book {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing book.
                books[selectedIndexPath.row] = book
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new book.
                let newIndexPath = IndexPath(row: books.count, section: 0)
                
                books.append(book)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the books.
            saveBooks()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleBooks() {
        
        let photo1 = UIImage(named: "book1")
        let photo2 = UIImage(named: "book2")
        let photo3 = UIImage(named: "book3")

        guard let book1 = Book(nombre: "Los Juegos del Hambre", portada: photo1, puntuacion: 4, autor: "Suzanne Collins", genero: "Literatura Juvenil") else {
            fatalError("Unable to instantiate book1")
        }

        guard let book2 = Book(nombre: "Invisible", portada: photo2, puntuacion: 5, autor: "Eloy Moreno", genero: "Literatura Juvenil") else {
            fatalError("Unable to instantiate book2")
        }

        guard let book3 = Book(nombre: "Tierra", portada: photo3, puntuacion: 3, autor: "Eloy Moreno", genero: "Ficcion") else {
            fatalError("Unable to instantiate book3")
        }

        books += [book1, book2, book3]
    }
    
    private func saveBooks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(books, toFile: Book.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Books successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save books...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadBooks() -> [Book]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Book.ArchiveURL.path) as? [Book]
    }

}
