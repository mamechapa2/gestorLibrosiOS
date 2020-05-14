import UIKit
import os.log
import UserNotifications

var books = [Book]()
class BookTableViewController: UITableViewController, UNUserNotificationCenterDelegate {
    
    //MARK: Propiedades y constructores
    
    //Variable que controla las notificaciones
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func requestNotificationAuthorization()
    {
        //Pedir permiso del usuario
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    //Constructores para las notificaciones
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    func enviarNotificacion(titulo: String, mensaje: String)
    {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = titulo
        notificationContent.body = mensaje
        notificationContent.badge = NSNumber(value: 3)
        // Trigger para determinar el tiempo máximo
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "alerta",
                                            content: notificationContent,
                                            trigger: trigger)
        //Pedimos la solicitud
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //pedir permiso alertas
        self.userNotificationCenter.delegate = self
        self.requestNotificationAuthorization()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // cargar libros, si no, los de prueba
        if let savedBooks = loadBooks() {
            books += savedBooks
        }
        else {
            // Carga los datos de prueba
            loadSampleBooks()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Libera recursos
    }

    //MARK: - Métodos de la tabla

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Las celdas tienen un identificador
        let cellIdentifier = "BookTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BookTableViewCell  else {
            fatalError("The dequeued cell is not an instance of BookTableViewCell.")
        }
        
        // Busca el libro
        let book = books[indexPath.row]
        
        cell.nameLabel.text = book.nombre
        cell.photoImageView.image = book.portada
        cell.ratingControl.rating = book.puntuacion
        // Devuelve la celda
        return cell
    }
    

    
    // Para determinar si se edita
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Devolver falso si no es editable
        return true
    }
    

    
    // Método para editar celdas
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Borrar el libro de la base de datos
            books.remove(at: indexPath.row)
            saveBooks()
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.enviarNotificacion(titulo: "Se ha borrado el libro", mensaje: "")
        } else if editingStyle == .insert {
            // Crea una instancia nueva de libro y lo inserta
        }    
    }
    //MARK: - Navegación

    //Preparación
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            //Agregar un libro nuevo
        case "AddItem":
            os_log("Adding a new book.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let bookDetailViewController = segue.destination as? BookViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedBookCell = sender as? BookTableViewCell else {
                fatalError("Unexpected sender: \(sender ?? "")")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedBookCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedBook = books[indexPath.row]
            bookDetailViewController.book = selectedBook
            //Iniciar nueva vista con el libro seleccionado
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
        }
    }

    
    //MARK: Acciones
    
    @IBAction func unwindToBookList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? BookViewController, let book = sourceViewController.book {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Editar un libro
                books[selectedIndexPath.row] = book
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                self.enviarNotificacion(titulo: "Libro editado", mensaje: "Se ha editado "+book.nombre)
            }
            else {
                // Agregar un libro
                let newIndexPath = IndexPath(row: books.count, section: 0)
                
                books.append(book)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                self.enviarNotificacion(titulo: "Libro creado", mensaje: "Se ha creado " + book.nombre)
            }
            
            // Guardar los libros
            saveBooks()
        }
    }
    
    //MARK: Métodos privados
    
    private func loadSampleBooks() {
        //Construcción de los libros de prueba
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
        //Los agregamos a la vista principal y a la base de datos
        books += [book1, book2, book3]
    }
    
    private func saveBooks() {
        //Llamamos a NSCoder para guardar los libros
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(books, toFile: Book.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Books successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save books...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadBooks() -> [Book]?  {
        //Cargamos los libros
        return NSKeyedUnarchiver.unarchiveObject(withFile: Book.ArchiveURL.path) as? [Book]
    }

}
