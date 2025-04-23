import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Lütfen tüm alanları doldurun.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Kayıt hatası: \(error.localizedDescription)")
                return
            }

            print("Kayıt başarılı!")
            self.performSegue(withIdentifier: "RegisterToNotes", sender: self)

        }
    }
    
    @IBAction func goToLoginButton(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterToLogin", sender: self)

    }
    
}
