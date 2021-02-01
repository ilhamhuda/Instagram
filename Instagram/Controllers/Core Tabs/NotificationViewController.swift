//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Ilham Huda on 19/01/21.
//

import UIKit

enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = false
        tableView.register(NotificationLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationLikeEventTableViewCell.identifier)
        tableView.register(NotificationFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationFollowEventTableViewCell.identifier)
        return tableView
    }()
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    private  lazy var noNotificaitonView = NoNotificationsView()
    
    private var models = [UserNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Notifications"
        fetchNotification()
        view.backgroundColor = .systemBackground
        
//        view.addSubview(noNotificaitonView)
        view.addSubview(spinner)
        view.addSubview(tableView)
//        spinner.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func fetchNotification() {
        for x in 0...100 {
            
            let user = User(
                username: "ilham",
                bio: "",
                name: (first: "Ilham", last: "Huda"),
                birthDate: Date(),
                gender: .Male,
                profilePhoto: URL(string: "https://www.google.com")!,
                counts: UserCount(followers: 1, following: 1, posts: 1),
                JoinDate: Date())
            
            let post = UserPost(identifier: "",
                postType: .photo,
                thumbnailImage: URL(string: "https://www.google.com")!,
                caption: nil,
                postURL: URL(string: "https://www.google.com")!,
                likeCount: [],
                Comments: [],
                createdDate: Date(),
                taggedUSers: [],
                owner: user
            )
            
            
            let model = UserNotification(type: x % 2 == 0 ? .like(post: post): .follow(state: .not_following),
                                         text: "Hello World",
                                         user: user)
            models.append(model)
           
        }
        print("model data : ", models)
    }
    
    
    private func addNoNotificationsView() {
        tableView.isHidden = true
        view.addSubview(tableView)
        noNotificaitonView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: view.width/2,
                                           height: view.width/2)
        noNotificaitonView.center = view.center
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->UITableViewCell{
        let model = models[indexPath.row]
        switch model.type {
        case .like:
            let cell  = tableView.dequeueReusableCell(withIdentifier: NotificationLikeEventTableViewCell.identifier, for: indexPath) as! NotificationLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
         return cell
        case .follow:
        let cell  = tableView.dequeueReusableCell(withIdentifier: NotificationFollowEventTableViewCell.identifier, for: indexPath) as! NotificationFollowEventTableViewCell
//        cell.configure(with: model)
        cell.delegate = self
        return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
}

extension NotificationViewController: NotificationLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        print("Tapped post")
        switch model.type {
        case .like(let post):
            let vc = PostViewController(model: post)
            vc.title = post.postType.rawValue
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            print("Tapped post")
        case .follow(_):
            fatalError("Dev Issues: Should Never get Called")
        }
    }
}


extension NotificationViewController: NotificationFollowEventTableViewCellDelegate {
    func didTapFolloUnFollowButton(model: UserNotification) {
        print("tapped Follow")
    }
}
