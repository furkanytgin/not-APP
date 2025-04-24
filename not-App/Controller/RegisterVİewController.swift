import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        loadingIcon.startAnimating()
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Lütfen tüm alanları doldurun.")
            showAlert(title: "Eksik Bilgi", message: "Lütfen tüm alanları doldurun.")
            self.loadingIcon.stopAnimating()

            return
        }
        if !email.contains("@") || !email.contains(".") {
               showAlert(title: "Hatalı E-posta", message: "Lütfen geçerli bir e-posta adresi girin.")
            self.loadingIcon.stopAnimating()

               return
           }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Kayıt hatası: \(error.localizedDescription)")
                self.showAlert(title: "Kayıt Hatası", message: error.localizedDescription)
                self.loadingIcon.stopAnimating()
                return
            }
            let alert = UIAlertController(title: "Başarılı", message: "Kayıt başarılı!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { _ in
                self.loadingIcon.stopAnimating()
                print("Kayıt başarılı!")
                self.performSegue(withIdentifier: "RegisterToNotes", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
                                                
        }
    }
    
    @IBAction func goToLoginButton(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterToLogin", sender: self)

    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            registerButtonTapped(registerButtonOutlet) // ENTER tuşu bu fonksiyonu tetikler
        }
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
