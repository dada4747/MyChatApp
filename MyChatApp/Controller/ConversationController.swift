//
//  ConversationController.swift
//  MyChatApp
//
//  Created by gadgetzone on 08/08/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "ConversationCell"

class ConversationController: UIViewController {
    
    // MARK: - Properties

    let tableView = UITableView()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authenticateUser()
    }
    
    // MARK: - Selector
    // MARK: - FIXME
    @objc func showProfile() {
        print("this is show profile func ")
        logout()
    }
    
    // MARK: - API
    
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
        } else {
            print("user is already login user id is \(Auth.auth().currentUser?.uid ?? "") ")
        }
    }
    
    func logout() {
        do {
            try  Auth.auth().signOut()
            presentLoginScreen()
        } catch {
            print("DEBUG: Error in signing out ")
        }
    }
    
    // MARK: - Helper
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        configureNavBar()
        configureTableView()
        
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold, scale: .unspecified)
        let profileIcon = UIImage(systemName: "person.crop.circle", withConfiguration: config )
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showProfile))
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
    }
    
    func configureNavBar() {
        let appearanc = UINavigationBarAppearance()
        appearanc.configureWithOpaqueBackground()
        appearanc.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearanc.backgroundColor = .darkGray
        
        navigationController?.navigationBar.standardAppearance   = appearanc
        navigationController?.navigationBar.compactAppearance    = appearanc
        navigationController?.navigationBar.scrollEdgeAppearance = appearanc
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Messages"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
    }
}

// MARK: - UITableViewDataSource
extension ConversationController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath)
        cell.textLabel?.text = "Contact Name..."
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ConversationController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row )
    }

}
