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
        tableView.tableHeaderView = createTableHeader()
    }
    
    func createTableHeader( ) -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let fileName = "\(safeEmail)_profile_picture.png"
        let path = "images/" + fileName
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 300) )
        headerView.backgroundColor = .link
        
        let imageView = UIImageView(frame: CGRect(x: (headerView.width - 150)/2, y: 75, width: 150, height: 150))
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width / 2 
        headerView.addSubview(imageView)
        StorageManager.shared.downloadURL(for: path, completion: {[weak self] result in
            switch result {
            case .success(let url):
                self?.downloadImg(imageView: imageView, url: url)
            case .failure(let error):
                print("Faild to download url : \(error)")
            }
        })
        
        return headerView
    }
    func downloadImg ( imageView : UIImageView , url  : URL){
        URLSession.shared.dataTask(with: url, completionHandler: {data, _ , error in
            guard let data = data , error == nil else {
                return
            }
            DispatchQueue.main.async {
                let img = UIImage(data: data)
                imageView.image = img
                
            }
            
        }).resume()
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
