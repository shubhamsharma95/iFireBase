//
//  UsersListViewController.swift
//  iFireBase
//
//  Created by Rahul on 05/11/18.
//  Copyright © 2018 arka. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
class UsersListViewController: UIViewController {
    
    @IBOutlet weak var usersTable: UITableView!
    
    fileprivate var ref: DatabaseReference!
    fileprivate var messages: [DataSnapshot]! = []
    fileprivate var msglength: NSNumber = 10
    fileprivate var _refHandle: DatabaseHandle?
    
    @IBOutlet weak var logout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()
        
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        // Listen for new messages in the Firebase database
        _refHandle = self.ref.child("users").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else { return }
            if snapshot.key == Auth.auth().currentUser?.uid {return}
            strongSelf.messages.append(snapshot)
            strongSelf.usersTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
        })
    }
    
    @IBAction func logout(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error logout!!!!!!")
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        let editProfileViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
       
        self.navigationController?.pushViewController(editProfileViewController, animated: true)
    }
    
}


extension UsersListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersListTableViewCell", for: indexPath) as! UsersListTableViewCell
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:Any] else { return cell }
        print(messageSnapshot.key)
        let name = message["profileDisplayName"] as? String ?? ""
        cell.nameLabel.text = name
        
        downloadProfilePic(uid: messageSnapshot.key, profieImage: cell.profilePic)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        let messageSnapshot: DataSnapshot! = self.messages[indexPath.row]
        chatViewController.chatWith = messageSnapshot.key
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    fileprivate func downloadProfilePic(uid:String, profieImage:UIImageView) {
       
            let storage = Storage.storage()
            
            let storageRef = storage.reference(withPath:"profile/user_\(uid).jpg")//.child("2465785.jpg") //forURL:"gs://developers-point.appspot.com/2465785.jpg"
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                    // Uh-oh, an error occurred!
                } else {
                    // Data for "images/island.jpg" is returned
                    let imagex = UIImage(data: data!)
                    profieImage.image = imagex
                }
            }
      
    }
}
