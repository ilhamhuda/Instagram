//
//  SettingViewController.swift
//  Instagram
//
//  Created by Ilham Huda on 20/01/21.
//

import UIKit
import SafariServices

struct SettingCellMode {
    let title: String
    let handler: (() -> Void)
}

class SettingViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                     style:.grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[SettingCellMode]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configureModels()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        
        
        
        data.append([
            SettingCellMode(title: "Edit Profile") { [weak self] in
                self?.didTapEditProfile()
            },
            SettingCellMode(title: "Invite Friends") { [weak self] in
                self?.didTapEditInviteFriends()
            },
            SettingCellMode(title: "Save Original Posts") { [weak self] in
                self?.didTapEditSaveOriginalPosts()
            }
        ])
        
        data.append([
            SettingCellMode(title: "Terms of Service") { [weak self] in
                self?.openURL(type: .terms)
            },
            SettingCellMode(title: "Privacy Policy") { [weak self] in
                self?.openURL(type: .privacy)

            },
            SettingCellMode(title: "Help/ Feedback") { [weak self] in
                self?.openURL(type: .help)

            }
        ])
        
        
        
        data.append([
            SettingCellMode(title: "Log Out") { [weak self] in
                self?.didTapLogout()
            }
        ])
    }
    
    enum SettingsURLType {
        case terms, privacy, help
    }
    
    private func openURL(type: SettingsURLType){
        let urlString: String
        switch type {
        case .terms: urlString = "https://help.instagram.com/581066165581870"
        case .privacy: urlString = "https://help.instagram.com/519522125107875"
        case .help: urlString = "https://help.instagram.com"        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    private func didTapEditProfile() {
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    private func didTapEditInviteFriends() {
        
    }
    
    private func didTapEditSaveOriginalPosts() {
        
    }
    
  
    private func didTapLogout() {
        let actionSheet = UIAlertController( title: "Logout", message: "Are you sure you want logout?", preferredStyle: .actionSheet
        )
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            
            AuthManager.shared.logOut(completion: { success in
                DispatchQueue.main.async {
                    if success {
                        let loginVC = LoginViewController()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true) {
                            self.navigationController?.popViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                        }
                    }
                    else {
                        //error occured
                        fatalError("Could not log out user")
                    }
                }
                
            })
            
        }))
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
       present(actionSheet, animated: true)
    }

}

extension SettingViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
}


