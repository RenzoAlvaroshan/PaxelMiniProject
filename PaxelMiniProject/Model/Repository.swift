//
//  Repository.swift
//  PaxelMiniProject
//
//  Created by Renzo Alvaroshan on 08/10/22.
//

import Foundation

// MARK: - Welcome
struct RepositoryResponse: Codable {
    let repositories: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case repositories = "items"
    }
}

// MARK: - Item
struct Repository: Codable {
    let fullName: String
    let owner: Owner
    let itemDescription: String

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case owner
        case itemDescription = "description"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String
    let avatarURL: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}
