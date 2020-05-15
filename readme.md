# uRead

Documentación

```
Alfonso José Arroyo Loaisa
Orestes Colomina Monsalve
```

## Indice

## Indice

- Indice
- ¿Que es uRead?
- ¿Como funciona la app?
   - 1. Pantalla principal
   - 2. Creacion de un nuevo libro
   - 3. Edición y visualización de un libro
   - 4. Pantalla de favoritos
- Descarga


## ¿Que es uRead?

La aplicación uRead es un gestor de libros disponible para iOS. Añades tu colección de
libros y la puedes visualizar desde tu teléfono. También puedes ver tus libros favoritos y
puedes ponerle una clasificación de 1 a 5 estrellas. En todo momento podrás editar cada
uno de los libros, modificar su título, autor, género e incluso su portada.


## ¿Como funciona la app?

### 1. Pantalla principal

Nada mas iniciar la aplicación nos encontraremos con la
pantalla inicial, donde tendremos una lista con todos
nuestros libros. Desde esta vista podremos editar la lista
de libros, eliminando o añadiendo todos los libros que
queramos mediante los botones que estan en la parte
superior.
Si es la primera vez que abrimos la app, se nos cargaran
unos libros de ejemplo.
Si pulsamos en el boton de edicion de arriba a la
izquierda, entraremos en el modo de edicion, donde
podremos eliminar cada uno de los libros.
Y si pulsamos en el boton + arriba a la derecha
entraremos en el modo de creacion de un nuevo libro,
vista que sera explicada mas adelante.

```
A nivel de programacion, esta vista esta formada por una
table view en la que cada libro consiste en una table view
cell que contiene el titulo del libro, su portada y su
puntuacion.
```
```
Abajo hay una tab bar con un acceso a la vista de los
libros favoritos del usuario y a esta misma vista.
```
```
En la parte superior tenemos dos botones, uno para
borrar los libros y el otro para añadir un nuevo libro al
sistema. Si pinchamos en un libro accedemos a su
visualización y si quisiéramos, modificarlo.
```
```
Para eliminar un libro, vamos a ver cómo lo
seleccionamos para borrarlo. Comprobamos si el
editingStyle es .delete. EditingStyle es un parámetro de
tipo UITableCell.EditingStyle, que indica el estilo de la
celda de una tabla:
```

if editingStyle == .delete {
books.remove(at: indexPath.row)
saveBooks()
tableView.deleteRows(at: [indexPath], with: .fade)
self.enviarNotificacion(titulo: "Se ha borrado el libro", mensaje: "")
}

Siguiendo el código, borramos el libro en el índice seleccionado, guardamos
inmediatamente (sera explicado mas adelante como se guardan y cargan los libros) y lo
borramos de la vista.
Por último enviamos la notificación de que hemos borrado el libro.

Tambien vamos a ver que hace la vista principal nada mas cargarse, en su metodo
viewDidLoad():
override func viewDidLoad() {
super.viewDidLoad()
=/pedir permiso alertas
self.userNotificationCenter.delegate = self
navigationItem.leftBarButtonItem = editButtonItem
=/ cargar libros, si no, carga los de prueba
if let savedBooks = loadBooks() {
books += savedBooks
}
else {
loadSampleBooks()
}
}
Pedimos el permiso de las notificaciones y luego asignamos el delegado de las
notificaciones a la propia vista, para que salgan mientras esté abierta. Asignamos el botón
de editar y cargamos los libros.
¿Cómo se muestran los libros? Sobreescribimos la función tableView que crea la tabla.
override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
IndexPath) => UITableViewCell {
let cellIdentifier = "BookTableViewCell"
guard let cell = tableView.dequeueReusableCell(withIdentifier:
cellIdentifier, for: indexPath) as? BookTableViewCell else {
fatalError("The dequeued cell is not an instance of
BookTableViewCell.")
}
let book = books[indexPath.row]
cell.nameLabel.text = book.nombre
cell.photoImageView.image = book.portada
cell.ratingControl.rating = book.puntuacion

return cell
}
Cada celda tiene un libro que se compone del título, su imagen y su puntuación con el
RatingControl.


### 2. Creacion de un nuevo libro

```
Si desde la vista principal pulsamos en el botón +,
entraremos a la vista de creación de un nuevo libro.
```
```
En esta vista podremos añadir el nombre del libro, su
autor y su genero, asi como su portada y su
puntuación. Tambien tendremos un switch que
añadirá el libro a favoritos, si queremos, y podremos
verlo en la vista de favoritos, que explicaremos mas
adelante.
```
```
Cuando terminemos de añadir toda la información
del libro, el boton de Guardar se habilitará y
podremos guardar el libro. Cuando el libro sea
guardado, también saldrá una notificación
informando de que se ha creado un nuevo libro.
```
A nivel de programación, esta vista está formada por
text fields, un switch, un image view y un stack view que
se ha personalizado para que pueda ser usado para la
puntuación del libro.

Para las notificaciones primero hemos importado la
biblioteca UserNotifications, seguidamente de
implementar dos constructores sencillos para permitir
que las notificaciones salgan cuando la aplicación está
encendida (foreground).

Declaramos una variable userNotificationCenter que es
la que maneja todas las notificaciones. En el método
viewDidLoad() de la vista principal, aparte de cargar
toda la vista y los libros, tenemos que configurar las
notificaciones.

Primero tenemos que pedir permiso al usuario de
mostrar notificaciones, lo hacemos con el método
requestNotificationAuthorization() y se encarga de


mostrar la ventana para el permiso, también notifica qué tipo de alertas se van a enviar.
Luego asignamos el delegado de las notificaciones a la propia vista para que salgan las
alertas cuando la aplicación está en primer plano.

Una vez aceptado el permiso, se envían las notificaciones con el método
enviarNotificacion(String, String) y son personalizadas. Simplemente envía una notificación
con un título y una descripción que nosotros pongamos. La notificación contiene un icono
propio de la aplicación para que tenga más detalle.
El código es el siguiente:
func enviarNotificacion(titulo: String, mensaje: String)
{
let notificationContent = UNMutableNotificationContent()
notificationContent.title = titulo
notificationContent.body = mensaje
notificationContent.badge = NSNumber(value: 3 )

let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 ,
repeats:
false)
let request = UNNotificationRequest(identifier: "alerta",
content: notificationContent, trigger: trigger)
userNotificationCenter.add(request) { (error) in
if let error = error {
print("Notification Error: ", error)
}
}
}
Construimos la notificación con una serie de parámetros.
El badge numer indica el número máximo de alertas que se pueden enviar.
El trigger es un tiempo en segundos hasta que aparece la notificación, lo hemos puesto a 5.
Por último enviamos una peticion al sistema operativo y se muestra la alerta.


### 3. Edición y visualización de un libro

La vista que corresponde a la edición / visualización es
igual a la vista de agregar un nuevo libro. Accederemos
a ella desde la vista principal si hacemos click en un
libro. Internamente se prepara construyendo el libro en la
función viewDidLoad()

En ella podremos editar todos los atributos del libro de la
misma forma que lo haríamos en la vista de añadir un
libro nuevo. Una vez hayamos terminado, lo podremos
guardar.

Al igual que al crear el libro, una vez editado nos saldrá
una notificacion.

En las imágenes de abajo podemos ver también como
añadimos una imagen al libro que hemos creado
anteriormente, lo añadimos a favoritos y cambiamos su
puntuación. Una vez guardado es visualizado
correctamente en la vista principal y podemos ver como
también se muestra la notificación indicando que el libro
ha sido editado.

El botón de guardar se deshabilita si estamos escribiendo en él gracias al evento
textFieldDidBeginEditing. Hay dos eventos más que permiten ocultar el teclado y
que vuelvan a activar el botón de guardado. Siempre se puede cancelar el proceso.

En las imágenes de abajo se muestra el proceso de la edición de un libro para añadir una
imagen, esto es posible con funcionalidad nativa de IOS.
let imagePickerController = UIImagePickerController()
imagePickerController.sourceType = .photoLibrary

imagePickerController.delegate = self
Le indicamos al controlador que sólo nos pille las fotos que tengamos en el dispositivo y
asignamos el delegado a la propia vista para que notifique y envíe la imagen.


El controlador guarda la información para volver a enviarla a la vista:
let name = nameTextField.text =? ""
let photo = photoImageView.image
let rating = ratingControl.rating
let autor = autorTextField.text =? ""
let favorito = favSwitch.isOn

book = Book(nombre: name, portada: photo, puntuacion: rating, autor:
autor, genero: genero, favorito: favorito)

Ahora que ya hemos visto las dos vistas tanto de edición como de creación de un nuevo
libro, podemos explicar como funciona el guardado y cargado de libros.

El guardado y cargado se hace con NSCoding.

El guardado es muy sencillo, se llama a la función encode con el parámetro de la clase y su
propiedad. Lo hace automáticamente y no nos tenemos que preocupar de gestionar varios
tipos de variables y booleanos. Todo esto se realiza en la función saveBooks().
El codificamiento se hace en el modelo del libro como se puede ver aquí:
func encode(with aCoder: NSCoder) {
aCoder.encode(nombre, forKey: PropertyKey.nombre)
aCoder.encode(portada, forKey: PropertyKey.portada)
aCoder.encode(puntuacion, forKey: PropertyKey.puntuacion)
aCoder.encode(autor, forKey: PropertyKey.autor)
aCoder.encode(genero, forKey: PropertyKey.genero)
aCoder.encode(favorito, forKey: PropertyKey.favorito)
}
El cargado es más complejo ya que tenemos que comprobar siempre si es nulo, si no, falla
la carga. La imagen sin embargo es opcional, entonces no lo tenemos que comprobar.
let portada = aDecoder.decodeObject(forKey: PropertyKey.portada) as? UIImage
let puntuacion = aDecoder.decodeInteger(forKey: PropertyKey.puntuacion)
guard let autor = aDecoder.decodeObject(forKey: PropertyKey.autor) as? String
else {
os_log("Unable to decode the name for a book object.", log:
OSLog.default, type: .debug)
return nil
}
En este trozo de código enseño cómo cargo la portada que es opcional y los parámetros
obligatorios como el autor.
Por último construimos el libro con todos los parámetros cargados de la siguiente forma:
self.init(nombre: nombre, portada: portada, puntuacion: puntuacion,
autor: autor, genero: genero, favorito: favorito).
En el controlador principal, cargamos los libros guardados
private func loadBooks() => [Book]? {
return NSKeyedUnarchiver.unarchiveObject(withFile:
Book.ArchiveURL.path) as? [Book]
}


### 4. Pantalla de favoritos

Mediante la tab bar podemos acceder a la vista de
favoritos, que es igual a la vista de libros pero solo
muestra una lista con todos los libros que hemos
añadido a favoritos. Esta pantalla no realizara
ninguna otra accion, solo servirá para visualizar los
libros favoritos.

A nivel de programación, esta vista es como la vista
principal pero con menos funcionalidades. Al cambiar
a esta vista haremos una llamada a la función
realoadFavBooks():

func reloadFavBooks(){

favBooks.removeAll()

for book in books {

if(book.favorito){

```
favBooks.append(book)
```
#### }

#### }

tableView.reloadData()

#### }

Esta función es llamada desde la funcion viewWillAppear() y tambien en viewDidLoad().
Primero quitamos todos los libros de la vista, luego iteramos por toda la colección y sólo lo
agrega si es un favorito, que lo habrá marcado el usuario anteriormente mediante el switch.
La vista quedaría como se ve en la imagen.


## Descarga

El proyecto está disponible en Github:
https://github.com/mamechapa2/gestorLibrosiOS

La ultima version puede ser descargada aqui:
https://github.com/mamechapa2/gestorLibrosiOS/releases


