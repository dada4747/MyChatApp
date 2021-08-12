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
    private let newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "newChat.png"), for: .normal)
        //button.backgroundColor = .systemPink
        button.tintColor = .darkGray
        button.imageView?.setDimensions(height: 80, width: 80)
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()

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
    
    @objc func showNewMessage() {
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
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

        configureNavBar(withTitle: "Messages", preferLargeTitles: true)

        configureTableView()
        
        let config = UIImage.SymbolConfiguration(pointSize: 28,
                                                 weight: .bold,
                                                 scale: .unspecified)
        let profileIcon = UIImage(systemName: "person.crop.circle", withConfiguration: config )
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: profileIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showProfile))
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 80, width: 80)
        newMessageButton.layer.cornerRadius = 6
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                right: view.rightAnchor,
                                paddingBottom: 10,
                                paddingRight: 20)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.rowHeight       = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate        = self
        tableView.dataSource      = self
        
        view.addSubview(tableView)
        tableView.frame           = view.frame
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

// MARK: - NewMessageControllerDelegate

extension ConversationController: NewMessageControllerDelegate {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        controller.dismiss(animated: true, completion: nil)
        let chat = ChatController(user: user)
        navigationController?.pushViewController(chat, animated: true)
    }
}
