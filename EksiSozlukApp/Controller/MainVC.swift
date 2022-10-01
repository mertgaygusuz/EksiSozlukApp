//
//  MainVC.swift
//  EksiSozlukApp
//
//  Created by Mert Gaygusuz on 28.09.2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class MainVC: UIViewController {
    
    
    @IBOutlet weak var segmentCategories: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var contents = [Content]()
    
    private var contentsCollectionRef : CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.estimatedRowHeight = 80
        //tableView.rowHeight = UITableView.automaticDimension
        
        contentsCollectionRef = Firestore.firestore().collection(Contents)
    }


    override func viewWillAppear(_ animated: Bool) {
        
        contentsCollectionRef.getDocuments { (snapshot, error) in
            if let error = error {
                debugPrint("Entryleri getirirken hata meydana geldi: \(error.localizedDescription)")
            } else {
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    
                    let data = document.data()
                    
                    let userName = data[UserName] as? String ?? "Ziyaretçi"
                    let dateOfUpload = data[DateOfUpload] as? Date ?? Date()
                    let contentText = data[ContentText] as? String ?? ""
                    let numberOfComments = data[NumberOfComments] as? Int ?? 0
                    let numberOfLikes = data[NumberOfLikes] as? Int ?? 0
                    let documentId = document.documentID
                    
                    let newContent = Content(userName: userName, dateOfUpload: dateOfUpload, contentText: contentText, numberOfComments: numberOfComments, numberOfLikes: numberOfLikes, documentId: documentId)
                    self.contents.append(newContent)
                }
                self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

