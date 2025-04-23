//
//  ViewController.swift
//  not-App
//
//  Created by furkan yetgin on 23.04.2025.
//

import UIKit
import FirebaseFirestore

class EditViewController: UIViewController {

    var note: Note?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        title = "Düzenle yada Sil"
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let note = note {
            titleTextField.text = note.title
            contentTextView.text = note.content
        } else {
            title = "New Note"
        }
    }

    @IBAction func updateNoteButton(_ sender: UIButton) {
        guard let note = note else {
                   print("Not bulunamadı.")
                   return
               }
               
               // Güncelleme işlemi
               let updatedTitle = titleTextField.text ?? ""
               let updatedContent = contentTextView.text ?? ""
               
               if updatedTitle.isEmpty || updatedContent.isEmpty {
                   print("Başlık veya içerik boş olamaz.")
                   return
               }
               
               // Firestore'da notu güncelleme
               let db = Firestore.firestore()
               
               db.collection("notes").document(note.id).updateData([
                   "title": updatedTitle,
                   "content": updatedContent
               ]) { error in
                   if let error = error {
                       print("Not güncelleme hatası: \(error.localizedDescription)")
                   } else {
                       print("Not başarıyla güncellendi.")
                       // Güncelleme başarılı olduğunda geri dön
                       self.navigationController?.popViewController(animated: true)
                   }
               }
    }
    
    @IBAction func deleteNoteButton(_ sender: UIButton) {
        guard let note = note else {
                   print("Silinecek not bulunamadı.")
                   return
               }

               let db = Firestore.firestore()
               
               // Firestore'dan notu silme
               db.collection("notes").document(note.id).delete { error in
                   if let error = error {
                       print("Not silme hatası: \(error.localizedDescription)")
                   } else {
                       print("Not başarıyla silindi.")
                       // Silme işleminden sonra notlar sayfasına dön
                       self.navigationController?.popViewController(animated: true)
                   }
               }
    }
}

