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
    private let standardAppearance = UINavigationBarAppearance()
    
    private var users = [ [String : String]]( )
    private var results = [ [String : String]]( )
    
    private var hasFetched = false
    
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
        view.addSubview(noResoultsLabel)
        view.addSubview(tableView)
        
        tableView.delegate  = self
        tableView.dataSource = self
        standardAppearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame  = view.bounds
        noResoultsLabel.frame = CGRect(x: view.width / 4, y: (view.height - 200) / 2 , width: view.width, height: 200)
    }
    
    @objc private func dismissSelf( ){
        dismiss(animated: true)
    }
    
}
extension NewConversationViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text , !text.replacingOccurrences(of: " ", with: "").isEmpty else{
            return
        }
        searchBar.resignFirstResponder()
        results.removeAll()
        spinner.show(in: view)
        self.searchUsers(query: text)
    }
    
    func searchUsers(query : String){
        if hasFetched {
            filterUsers(with: query)
        }
        else {
            DatabaseManager.shared.getAllUsers { [weak self] result in
                switch result {
                case .success(let userCollection):
                    self?.hasFetched = true
                    self?.users = userCollection
                    
                    self?.filterUsers(with: query)
                case .failure(let error) :
                    print("Faild to get users \(error)")
                
                }
            }
        }
    }
    
    func filterUsers( with term : String){
        guard hasFetched else {
            return
        }
        self.spinner.dismiss(animated: true)
        let results : [ [String: String]] = self.users.filter {
            
            guard let name = $0["name"]?.lowercased()  else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        }
        self.results = results
        updateUI()
        
        
    }
    func updateUI() {
        if results.isEmpty{
            self.noResoultsLabel.isHidden = false
            self.tableView.isHidden = true
            
        }
        else {
            self.noResoultsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}

extension NewConversationViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
     
}
