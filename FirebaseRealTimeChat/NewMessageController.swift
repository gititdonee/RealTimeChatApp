//
//  NewMessageController.swift
//  FirebaseRealTimeChat
//
//  Created by will ullian on 12/24/16.
//  Copyright © 2016 will ullian. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    
    var users = [User]()
    
    var ref: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUser()
    }
    
    func fetchUser() {
        ref.child("Users").observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                print("Could not get snapshot.value")
                return
            }
            let user = User()
            user.name = dictionary["name"] as? String
            user.email = dictionary["email"] as? String
            user.profileImageUrl = dictionary["profileImageURL"] as? String
            
            self.users.append(user)
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                
            })
            
            print("User found")
            print(snapshot)
            }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        
        cell.textLabel!.text = user.name
        cell.detailTextLabel!.text = user.email
        
        if let profileImageURL = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageURL)
        } else {
            print("Could not get profileImageURL")
        }
        
        
                
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 70, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.size.width, height: textLabel!.frame.size.height)
        
        detailTextLabel?.frame = CGRect(x: 70, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.size.width, height: detailTextLabel!.frame.size.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Pottery.jpg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
