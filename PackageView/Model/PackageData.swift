//
//  PackageData.swift
//  PackageView
//
//  Created by Marin Todorov on 10/22/23.
//

import Foundation

struct PackageData: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case displayName = "manifest_display_name"
        case toolchainVersion = "tools_version"
        case platforms
        case products
        case targets
    }

    let name: String
    let displayName: String
    let toolchainVersion: String

    struct Platform: Codable, Hashable, Identifiable {
        var id: String { name }
        let name: String
        let version: String
    }

    let platforms: [Platform]

    struct Product: Codable, Hashable, Identifiable {
        enum ProductType: String, Codable {
            case library, executable, macro, test
        }
        var id: String { name }
        let name: String
        let targets: [String]
        let type: [String: [String]?]
    }

    let products: [Product]

    struct Target: Codable, Hashable, Identifiable {
        enum CodingKeys: String, CodingKey {
            case name
            case path
            case productDependencies = "product_dependencies"
            case productMemberships = "product_memberships"
            case targetDependencies = "target_dependencies"
            case sources
            case type
            case moduleType
        }

        var id: String { name }
        let name: String
        let path: String
        let productDependencies: [String]?
        let productMemberships: [String]?
        let targetDependencies: [String]?
        let sources: [String]?
        let type: String
        let moduleType: String?
    }

    let targets: [Target]
}
