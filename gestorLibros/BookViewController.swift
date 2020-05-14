
import UIKit
import os.log
import UserNotifications

class BookViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate {
    
    //MARK: Variables
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var autorTextField: UITextField!
    @IBOutlet weak var generoTextField: UITextField!
    @IBOutlet weak var favSwitch: UISwitch!

    var book: Book?
//Método que se carga cuando se inicia la vista
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        
        if let book = book {
            navigationItem.title = book.nombre
            nameTextField.text = book.nombre
            photoImageView.image = book.portada
            ratingControl.rating = book.puntuacion
            autorTextField.text = book.autor
            generoTextField.text = book.genero
            favSwitch.setOn(book.favorito, animated: true)
        }
        
        // Activar el botón de guardado si tiene un nombre
        updateSaveButtonState()
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Deshabilitar el teclado
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Esconder el teclado
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Cuando tenga un nombre, habilitar guardado
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Quitar el controlador de la imagen si se cancela
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
   
        // Seleccionar la imagen original
        guard let selectedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Configurar el ImageView para que muestre la portada
        photoImageView.image = selectedImage
        
        // Liberar recursos
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navegación
    
    
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        //Método para cancelar
        let isPresentingInAddBookMode = presentingViewController is UINavigationController
        //Si es para agregar simplemente quita la vista
        if isPresentingInAddBookMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The BookViewController is not inside a navigation controller.")
        }
    }
    // Este método configura un libro para enviarlo a una vista
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configurar el destinatario
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        //Construir libro
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        let autor = autorTextField.text ?? ""
        let genero = generoTextField.text ?? ""
        let favorito = favSwitch.isOn
        
        // Construir el libro para enviarlo
        book = Book(nombre: name, portada: photo, puntuacion: rating, autor: autor, genero: genero, favorito: favorito)
    }
    
    //MARK: Acciones
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Esconder el teclado al principio
        nameTextField.resignFirstResponder()
        
        // Controlador para escoger una imagen
        let imagePickerController = UIImagePickerController()
        
        // Configurar solo para que elija fotos
        imagePickerController.sourceType = .photoLibrary
        
        // Asegurarse de que se le notifica al controlador
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Métodos privados
    
    private func updateSaveButtonState() {
        // Deshabilitar el botón de guardado
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}


// Funciones de ayuda insertadas con Swift 4.2
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
