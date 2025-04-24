import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        loadingIcon.startAnimating()
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Eksik Bilgi", message: "Lütfen tüm alanları doldurun.")
            self.loadingIcon.stopAnimating()
            print("Lütfen tüm alanları doldurun.")
            return
        }
        // E-posta formatı kontrolü (basit kontrol)
           if !email.contains("@") || !email.contains(".") {
               showAlert(title: "Hatalı E-posta", message: "Lütfen geçerli bir e-posta adresi girin.")
               self.loadingIcon.stopAnimating()

               return
           }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Giriş hatası: \(error.localizedDescription)")
                self.showAlert(title: "Email veya parola hatası" , message: " alanları tekrar kontrol ediniz")
                self.loadingIcon.stopAnimating()

                return
            }
            
                print("Giriş başarılı!")
                self.loadingIcon.stopAnimating()
                self.performSegue(withIdentifier: "LoginToNotes", sender: self)
        }
    }
    
    @IBAction func goToRegisterButtonTapped(_ sender: UIButton) {
        // Register ekranına geç
        performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonTapped(loginButtonOutlet)
        }
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
