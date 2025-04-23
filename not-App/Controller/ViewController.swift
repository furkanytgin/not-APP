import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var loginButtonOutlet: UIButton!
    override func viewDidLoad() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        super.viewDidLoad()
    }

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Lütfen tüm alanları doldurun.")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Giriş hatası: \(error.localizedDescription)")
                return
            }

            print("Giriş başarılı!")
            self.performSegue(withIdentifier: "LoginToNotes", sender: self)
        }
    }

    @IBAction func goToRegisterButtonTapped(_ sender: UIButton) {
        // Register ekranına geç
        performSegue(withIdentifier: "LoginToRegister", sender: self)
    }
}


extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            loginButtonTapped(loginButtonOutlet) 
        }
        return true
    }
}
