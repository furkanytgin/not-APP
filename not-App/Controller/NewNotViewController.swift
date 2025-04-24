//
//  ViewController.swift
//  not-App
//
//  Created by furkan yetgin on 23.04.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NewNotViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Yeni Not"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveNoteButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextView.text, !content.isEmpty,
              let userID = Auth.auth().currentUser?.uid else {
            print("Eksik alan var veya kullanıcı oturumu yok.")
            return
        }
        loadingIcon.startAnimating()
        let noteData: [String: Any] = [
            "title": title,
            "content": content,
            "timestamp": Timestamp(date: Date()),
            "userID": userID
        ]
        
        db.collection("notes").addDocument(data: noteData) { error in
            if let error = error {
                self.loadingIcon.stopAnimating()
                print("Not kaydedilemedi: \(error.localizedDescription)")
            } else {
                print("Not başarıyla kaydedildi.")
                self.loadingIcon.stopAnimating()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

