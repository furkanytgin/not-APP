import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
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
