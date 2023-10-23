//
//  ContentView.swift
//  PackageView
//
//  Created by Marin Todorov on 10/22/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("lastURL") var lastURL: URL = .empty
    @EnvironmentObject var model: PackageModel

    var body: some View {
        VStack {
            NavigationSplitView {
                if model.url != nil && model.package != nil {
                    SidebarView()
                } else {
                    if model.isLoading {
                        ProgressView().scaleEffect(x: 0.5, y: 0.5)
                    } else {
                        VStack(alignment: .center) {
                            Text("Use Cmd + O to load a Swift package.")
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                }
            } content: {
                if model.url != nil && model.selectedProduct != nil {
                    ProductDetailView()
                }
            } detail: {
                if model.url != nil && model.selectedTarget != nil {
                    TargetDetailView()
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        selectAndOpen()
                    }, label: {
                        Image(systemName: "externaldrive")
                    })
                    .keyboardShortcut(KeyEquivalent("o"), modifiers: .command)
                }
            })
        }
        .background(Color("DetailsBackground"))
        .toolbar(content: {
            ToolbarItem(placement: .automatic) {
                Text("PackageView").font(.headline)
                    .foregroundColor(.primary)
                    .offset(y: -1)
            }
        })
        .task {
            do {
                if lastURL != .empty {
                    try model.loadPackage(at: lastURL)
                    return
                }
            } catch {}
            selectAndOpen()
        }
        .onReceive(model.$url, perform: { value in
            guard let value else { return }
            lastURL = value
        })
    }

    func selectAndOpen() {
        Task {
            if let url = Self.selectFolder(selected: lastURL != .empty ? lastURL : nil) {
                do {
                    try model.loadPackage(at: url)
                    lastURL = url
                } catch {
                    lastURL = .empty
                    _ = try? model.loadPackage(at: .empty)
                }
            }
        }
    }

    static func selectFolder(selected: URL? = nil) -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.title = "Select a project folder"
        if let selected {
            openPanel.directoryURL = selected
        }
        openPanel.allowedContentTypes = [.folder]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false

        guard openPanel.runModal() == .OK else {
            return nil
        }

        return openPanel.url
    }

}

extension URL {
    static let empty = URL(fileURLWithPath: "/")
}
