import Foundation
import SwiftUI

struct LinkButton: View {
    @State var hovering = false
    let source: String
    let targetURL: URL
    var iconName = "doc"
    var onClick: (() -> Void)? = nil

    var body: some View {
        Button {
            if targetURL != .empty {
                NSWorkspace.shared.open(targetURL)
            }
            if let onClick {
                onClick()
            }
        } label: {
            HStack {
                Image(systemName: iconName)
                Text(source)
                    .underline(hovering, color: .accentColor)
            }
        }
        .buttonStyle(.plain)
        .onHover(perform: { hovering in
            if targetURL != .empty || onClick != nil {
                self.hovering = hovering
            }
        })
    }
}
