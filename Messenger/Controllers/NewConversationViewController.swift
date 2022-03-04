//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Виталий on 01.03.2022.
//

import UIKit
import JGProgressHUD
class NewConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD( style: .dark)
    private    let standardAppearance = UINavigationBarAppearance()
    

    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar( )
        searchBar.placeholder = "Search for Users..."
        return searchBar
    }( )
    private let noResoultsLabel : UILabel = {
        let label = UILabel( )
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21)
        label.isHidden = true
        return label
    }( )
    
    private let tableView: UITableView = {
       let table = UITableView()
       table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
       return table
    }( )
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        standardAppearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    
    @objc private func dismissSelf( ){
        dismiss(animated: true)
    }
    
}
extension NewConversationViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
