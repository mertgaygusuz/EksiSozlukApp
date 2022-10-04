//
//  MainVC.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 28.09.2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class MainVC: UIViewController {
    
    
    @IBOutlet weak var segmentCategories: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var contents = [Content]()
    private var contentsCollectionRef : CollectionReference!
    private var contentsListener : ListenerRegistration!
    private var selectedCategory = Categories.Eglence.rawValue
    private var listenerHandle : AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        contentsCollectionRef = Firestore.firestore().collection(Contents)
    }

    override func viewWillDisappear(_ animated: Bool) {
        if contentsListener != nil {
            contentsListener.remove()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        listenerHandle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
    }
    
    func setListener() {
        
        if selectedCategory == Categories.Populer.rawValue {
            
            contentsListener = contentsCollectionRef
                .order(by: DateOfUpload, descending: true)
                .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    debugPrint("Entryleri getirirken hata meydana geldi: \(error.localizedDescription)")
                } else {
                    self.contents.removeAll()
                    self.contents = Content.fetchContent(snapshot: snapshot)
                    self.tableView.reloadData()
                }
                
            }
        } else {
    
            contentsListener = contentsCollectionRef.whereField(Category, isEqualTo: selectedCategory)
                .order(by: DateOfUpload, descending: true)
                .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    debugPrint("Entryleri getirirken hata meydana geldi: \(error.localizedDescription)")
                } else {
                    self.contents.removeAll()
                    self.contents = Content.fetchContent(snapshot: snapshot)
                    self.tableView.reloadData()
                }
                
            }
        }
        
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        
        switch segmentCategories.selectedSegmentIndex {
            case 0 :
                selectedCategory = Categories.Eglence.rawValue
            case 1 :
                selectedCategory = Categories.Gundem.rawValue
            case 2 :
                selectedCategory = Categories.Spor.rawValue
            case 3 :
                selectedCategory = Categories.Populer.rawValue
            default :
                selectedCategory = Categories.Eglence.rawValue
        }
        contentsListener.remove()
        setListener()
    }
    
    
    @IBAction func btnLogOutPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let sessionError as NSError{
            debugPrint("Oturum kapatılamadı: \(sessionError.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CommentsSegue" {
            
            if let targetVC = segue.destination as? CommentsVC {
                
                if let selectedContent = sender as? Content {
                    targetVC.selectedContent = selectedContent
                }
            }
        }
    }
}

extension MainVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as? ContentCell {
            cell.setView(content: contents[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "CommentsSegue", sender: contents[indexPath.row])
    }
    
    
    
}

