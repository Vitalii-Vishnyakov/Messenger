//
//  ViewController.swift
//  Messenger
//
//  Created by Виталий on 01.03.2022.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
class ConversationsViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    

    private let noConversationsYet: UILabel = {
        let label = UILabel()
        label.text = "No conversations"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21)
        label.isHighlighted = true
        return label
    }( )
    
    private let tableView : UITableView = {
       let table = UITableView( )
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }( )
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        fetchConverations( )
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        view.addSubview(tableView)
    }
    @objc private func didTapComposeButton ( ){
        let vc = NewConversationViewController( )
        let navVc = UINavigationController(rootViewController: vc )
        present(navVc, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth( )
    }


    private func validateAuth( ){
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController( )
            let nav = UINavigationController( rootViewController: vc)
            
        
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false, completion: nil)
        }
    }
    
    
   
    
    
    private func fetchConverations ( ){
        tableView.isHidden = false
    }
}


extension ConversationsViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hi"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController( )
        vc.title = "BAr Boo"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true )
    }
}
