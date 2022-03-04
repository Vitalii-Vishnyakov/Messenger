//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Виталий on 01.03.2022.
//

import UIKit

import FirebaseAuth

class ProfileViewController: UIViewController {

    
    @IBOutlet var tableView : UITableView!
    
    let data = ["Log out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

    

}

extension ProfileViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell .textLabel?.textColor = .red
        
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { [weak self] _ in
     
            do {
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginViewController( )
                let nav = UINavigationController( rootViewController: vc)
                
            
                nav.modalPresentationStyle = .fullScreen
                self?.present(nav, animated: true, completion: nil)
                
            } catch  {
                print("LogOut error")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert , animated: true, completion: nil)
       
    }
    
}
