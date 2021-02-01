//
//  File.swift
//  Instagram
//
//  Created by Ilham Huda on 27/01/21.
//

import Foundation

enum Gender {
    case Male, Female, Other
}

struct User {
    let username: String
    let bio: String
    let name: (first: String, last: String)
    let birthDate: Date
    let gender: Gender
    let profilePhoto : URL
    let counts: UserCount
    let JoinDate: Date
}

struct UserCount {
    let followers: Int
    let following: Int
    let posts: Int
}

public enum UserPostType: String {
    case photo = "Photo"
    case video = "Video"
}

public struct UserPost {
    let identifier: String
    let postType: UserPostType
    let thumbnailImage: URL
    let caption : String?
    let postURL: URL
    let likeCount: [PostLikes]
    let Comments : [PostComment]
    let createdDate: Date
    let taggedUSers: [String]
    let owner: User
}

struct PostComment {
    let identifier:String
    let username: String
    let text: String
    let createdDate: Date
    let likes: [CommentLike]
}

struct CommentLike {
    let username: String
    let postIdentify: String

}
struct PostLikes {
    let username: String
    let postIdentifier: String
}

