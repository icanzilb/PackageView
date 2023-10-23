//
//  PackageViewApp.swift
//  PackageView
//
//  Created by Marin Todorov on 10/22/23.
//

import SwiftUI

@main
struct PackageViewApp: App {
    let model = PackageModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
        .windowToolbarStyle(.unifiedCompact)
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentMinSize)
    }
}

extension String {
    var uppercasedFirstCharacter: String {
        guard !isEmpty else { return self }
        return first!.uppercased().appending(dropFirst())
    }
}
