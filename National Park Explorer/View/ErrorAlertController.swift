import UIKit

class ErrorAlertController {
    
    // creates an alert controller with some default options, and one ok button
    // for a basic alert/error dialog.
    
    static func alert(title: String = "Error", message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}
