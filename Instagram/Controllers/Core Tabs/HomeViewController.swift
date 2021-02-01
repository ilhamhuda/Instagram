//
//  ViewController.swift
//  Instagram
//
//  Created by Ilham Huda on 19/01/21.
//

import UIKit
import FirebaseAuth
import Firebase

struct HomeFeedRenderViewModel {
    let header: PostRenderViewModel
    let post : PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController, UITableViewDelegate {
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        tableView.register(IGFeedPostActionTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionTableViewCell.identifier)
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        createMockModels()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func createMockModels(){
            
            let user = User(
                username: "@ilhamhuda",
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
                caption: "nil",
                postURL: URL(string: "https://www.google.com")!,
                likeCount: [],
                Comments: [],
                createdDate: Date(),
                taggedUSers: [],
                owner: user)
       
            
        var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(
                PostComment(
                    identifier: "\(x)",
                    username: "@ilham",
                    text: "",
                    createdDate: Date(),
                    likes: [])
            
            )
            
        }
            
        for x in 0..<5 {
            let viewModel = HomeFeedRenderViewModel(header: PostRenderViewModel(renderType: .header(provide: user)),
                                                    post: PostRenderViewModel(renderType: .primaryContent(provide: post)),
                                                    actions: PostRenderViewModel(renderType: .actions(provide: "")),
                                                    comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            feedRenderModels.append(viewModel)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
        
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("Failed to Signout")
        }
        
    }
    
    
    private func handleNotAuthenticated() {
        
        if Auth.auth().currentUser == nil {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
         }
            
        
    }

}


extension HomeViewController: UITabBarDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let x = section
        let model : HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }

        else {
            let position = x % 4 == 0 ? x/4 : ((x-(x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
           // Header
            return 1
        }
        else if subSection ==  1 {
            // Post
            return 1
        }
        
        else if subSection ==  2 {
            // Actions
            
            return 1
        }
        
        else if subSection ==  3 {
            // Comments
            let commentModel = model.comments
            switch commentModel.renderType {
            case.comments(let comments): return comments.count > 2 ? 2 : comments.count
            case .header, .actions, .primaryContent: return 0
                @unknown default: fatalError("Invalid Case")
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else {
            let position = x % 4 == 0 ? x/4 : ((x-(x % 4)) / 4)
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
           // Header
            switch model.header.renderType {
            case.header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .comments, .actions, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection ==  1 {
            // Post
            switch model.post.renderType {
            case.primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
                
                cell.configure(with: post)
                return cell
            case .comments, .actions, .header: return UITableViewCell()
            }
        }
        
        else if subSection ==  2 {
            // Actions
            switch model.actions.renderType {
            case.actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionTableViewCell.identifier, for: indexPath) as! IGFeedPostActionTableViewCell
                cell.delegate = self
                return cell
            case .comments, .header, .primaryContent: return UITableViewCell()
            }
  
        }
        
        else if subSection ==  3 {
            // Comments
            switch model.comments.renderType {
            case.comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                return cell
            case .header, .actions, .primaryContent: return UITableViewCell()
            }
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection =  indexPath.section % 4
        if subSection == 0{
            return 70
        }
        else if subSection == 1 {
            return tableView.width
        }
        else if subSection == 2 {
            return 60
        }
        else if subSection == 3 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0

    }
}

extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        let actionSheet = UIAlertController(title: "Post Options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: {[weak self] _ in
            self?.reportPost()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
   
        
    }
    
    func reportPost() {
        
    }
}


extension HomeViewController:IGFeedPostActionTableViewCellDelegate {
    func didTapLikeButton() {
        print("like")
    }
    func didTapCommentButton() {
        print("komen")
    }
    func didTapSendButton() {
        print("send")
    }
}
