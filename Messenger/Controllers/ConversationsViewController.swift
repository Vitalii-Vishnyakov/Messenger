//
//  ViewController.swift
//  Messenger
//
//  Created by Виталий on 01.03.2022.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        if !isLoggedIn {
            let vc = LoginViewController( )
            let nav = UINavigationController( rootViewController: vc)
            nav.navigationBar.backgroundColor = .gray
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false, completion: nil)
        }
    }


}

