//
//  NewMessageController.swift
//  MyChatApp
//
//  Created by gadgetzone on 11/08/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}

class NewMessageController: UITableViewController {
    
    // MARK: - Properties
    
    private var users = [User]()
    
    weak var delegate: NewMessageControllerDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUsers()
    }
    
    // MARK: - Selector

    @objc func handleDissmiss() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    func fetchUsers() {
        Service.fetchUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helper
    
    func configureUI() {
        configureNavBar(withTitle: "New Message", preferLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                            target: self,
                                                            action: #selector(handleDissmiss))
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
    }
    

}

// MARK: - UITableViewDataSource

extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier,for: indexPath) as! UserCell
        cell.user = users[indexPath.row]

        return cell
    }
}


extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.controller(self, wantsToStartChatWith: users[indexPath.row])
    }
}
