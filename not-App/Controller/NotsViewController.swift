//
//  ViewController.swift
//  not-App
//
//  Created by furkan yetgin on 23.04.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NotsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notesTableView: UITableView!
    
    var notes: [Note] = []
    
    //cruddan dönüşü veriler güncellenmediği için
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Notlar Listesi"
        
        if Auth.auth().currentUser == nil {
            // storyboard daki Login ViewControllera geçiş yap
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            present(loginVC, animated: true, completion: nil)
        }
        
        notesTableView.dataSource = self
        notesTableView.delegate = self
        fetchNotes()
        // "+ Yeni Not Ekle" butonunu ekranın sağ alt köşesine sabitle
              let addButton = UIButton(type: .system)
              addButton.setTitle("+ Yeni Not Ekle", for: .normal)
              
              // Auto Layout ile butonu ekranın sağ alt köşesine yerleştiriyoruz
              addButton.translatesAutoresizingMaskIntoConstraints = false
              self.view.addSubview(addButton)
              
              // Sağ alt köşeye sabitleme
              NSLayoutConstraint.activate([
                  addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                  addButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
              ])
        addButton.addTarget(self, action: #selector(goToNewNotPageButton), for: .touchUpInside)

    }
    // "+ Yeni Not Ekle" butonuna tıklanınca yapılacak işlem
       @objc func goToNewNotPageButton() {
           performSegue(withIdentifier: "NotesToNewNot", sender: self)
       }
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            let alert = UIAlertController(title: "Emin Misin?", message: "Çıkış yapmak istediğine Emin misin?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Çıkış Yap", style: .default, handler: { _ in
                // Uygulamanın ana ekranını (rootViewController) LoginVC olarak ayarla
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                    let navVC = UINavigationController(rootViewController: loginVC) // navigation barlı olsun diye
                    
                    sceneDelegate.window?.rootViewController = navVC
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            }))
            //alert mesajını tetiklemesi için
            self.present(alert, animated: true, completion: nil)

            
        } catch let signOutError as NSError {
            print("Çıkış yapılamadı: %@", signOutError)
        }
    }
    
    func fetchNotes() {
        let db = Firestore.firestore()
        guard let currentUser = Auth.auth().currentUser else { return }
        db.collection("notes").whereField("userID", isEqualTo: currentUser.uid).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Notları çekme hatası: \(error.localizedDescription)")
            } else {
                self.notes = querySnapshot?.documents.compactMap { document -> Note? in
                    let data = document.data()
                    let title = data["title"] as? String ?? ""
                    let content = data["content"] as? String ?? ""
                    let id = document.documentID
                    return Note(id: id, title: title, content: content)
                } ?? []
                self.notesTableView.reloadData()
            }
        }
    }
    
    // TableViewda kaç satır olduğunu belirtme
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // TableViewda her hücreyi oluşturma
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.title  // Başlık olarak notun adını gösterecek
        return cell
    }
    
    // TableView hücresine tıklanıldığında düzenleme sayfasına gitme
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        performSegue(withIdentifier: "NotesToEditNot", sender: note)
    }
    
    // Segue için veriyi hazırlama (Not düzenleme sayfasına veri gönderme)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NotesToEditNot" {
            if let destinationVC = segue.destination as? EditViewController,
               let note = sender as? Note {
                destinationVC.note = note
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
           
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            
            // Firebase'den silme işlemi
            let noteToDelete = self.notes[indexPath.row]
            let docId = noteToDelete.id
            
            Firestore.firestore().collection("notes").document(docId).delete { error in
                if let error = error {
                    print("Silme hatası:", error.localizedDescription)
                    completionHandler(false)
                } else {
                    // Local'den de sil
                    self.notes.remove(at: indexPath.row)
                    self.notesTableView.deleteRows(at: [indexPath], with: .automatic)
                    completionHandler(true)
                }
            }
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
}

