//
//  ViewController.swift
//  not-App
//
//  Created by furkan yetgin on 23.04.2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class NotsViewController : UIViewController,UITableViewDelegate, UITableViewDataSource {
    
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
    }
    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        do {
                try Auth.auth().signOut()
                
                // Uygulamanın ana ekranını (rootViewController) LoginVC olarak ayarla
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                    let navVC = UINavigationController(rootViewController: loginVC) // navigation barlı olsun diye
                    
                    sceneDelegate.window?.rootViewController = navVC
                    sceneDelegate.window?.makeKeyAndVisible()
                }

            } catch let signOutError as NSError {
                print("Çıkış yapılamadı: %@", signOutError)
            }
    }
    
    @IBAction func goToNewNotPageButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "NotesToNewNot", sender: self)
    }
    
    func fetchNotes() {
            let db = Firestore.firestore()

            db.collection("notes").getDocuments { (querySnapshot, error) in
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
        
       
}

