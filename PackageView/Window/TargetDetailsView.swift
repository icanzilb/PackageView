//
//  TargetDetailsView.swift
//  PackageView
//
//  Created by Marin Todorov on 10/22/23.
//

import Foundation
import SwiftUI

struct TargetDetailView: View {
    @EnvironmentObject var model: PackageModel

    @State var targetDepsSection = false
    @State var productDepsSection = false
    @State var productMembershipsSection = false

    @State var sourcesVisible = false
    @State var targetDependenciesVisible = false
    @State var productDependenciesVisible = false
    @State var productMembershipVisible = false

    func targetIconWithName(_ name: String) -> String {
        if let target = model.target(withName: name) {
            return iconName(forProductType: target.type)
        } else {
            return "doc"
        }
    }

    func productIconWithName(_ name: String) -> String {
        print("product: \(name)")
        if let product = model.products.first(where: { prod in prod.name == name }) {
            print(product)
            return iconName(forProductType: product.type.keys.first!)
        } else {
            return "doc"
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(model.selectedTarget.name.uppercased())
                .font(.body.uppercaseSmallCaps().bold())
                .foregroundStyle(.secondary)
            Divider()

            ScrollViewReader { reader in
                ScrollView(.vertical) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: iconName(forProductType: model.selectedTarget.type))
                            Text(model.selectedTarget.type.uppercasedFirstCharacter)
                            Spacer()
                        }

                        if let moduleType = model.selectedTarget.moduleType {
                            HStack {
                                Image(systemName: iconName(forProductType: moduleType))
                                Text(moduleType.uppercasedFirstCharacter)
                                Text("Module")
                            }
                        }

                        HStack {
                            LinkButton(
                                source: model.selectedTarget.path,
                                targetURL: model.absolutePathFor(relativePath: model.selectedTarget.path),
                                iconName: "folder.badge.gearshape"
                            )
                        }

                        // MARK: - Sources

                        if let sources = model.selectedTarget.sources {
                            VStack(alignment: .leading) {
                                ForEach(Array(sources.prefix( sourcesVisible ? .max : 5)), id: \.self) { source in
                                    HStack {
                                        LinkButton(
                                            source: source,
                                            targetURL: model.absolutePathInTargetFor(relativePath: source)
                                        )
                                        .padding(1)
                                        Spacer()
                                    }
                                    .frame(maxWidth: .infinity)
                                }

                                if sources.count > 5 {
                                    Button(action: {
                                        sourcesVisible.toggle()
                                    }, label: {
                                        HStack {
                                            Image(systemName: !sourcesVisible ? "chevron.right" : "chevron.up")
                                            Text(!sourcesVisible ? "Display \(sources.count - 5) more files" : "Display less files")
                                        }
                                    })
                                    .buttonStyle(.plain)
                                    .padding(.top, 4)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.05))
                            )
                            .padding(.leading, 16)
                        }

                        // MARK: - Membership

                        if let dependencies = model.selectedTarget.productMemberships, dependencies.count > 1 {
                            HStack {
                                Button(action: {
                                    productMembershipsSection.toggle()
                                }, label: {
                                    HStack {
                                        Image(systemName: productMembershipsSection ? "chevron.down" : "chevron.right")
                                        Text("Imported by \(dependencies.count) products").bold().foregroundStyle(.secondary)
                                    }
                                })
                                .buttonStyle(.plain)
                                .padding(.top, 4)

                                Button {
                                    if model.productFilter.isEmpty {
                                        model.productFilter = Set(dependencies)
                                    } else {
                                        model.productFilter.removeAll()
                                    }
                                } label: {
                                    Image(systemName: "text.magnifyingglass")
                                        .bold(!model.productFilter.isEmpty)
                                }
                                .buttonStyle(.plain)
                                .padding(.top, 4)

                            }

                            if productMembershipsSection {

                                VStack(alignment: .leading) {
                                    ForEach(Array(dependencies.prefix( productMembershipVisible ? .max : 5)), id: \.self) { dep in
                                        HStack {
                                            LinkButton(
                                                source: dep,
                                                targetURL: .empty,
                                                iconName: productIconWithName(dep),
                                                onClick: {
                                                    model.selectedProduct = model.products.first(where: { prod in prod.name == dep })
                                                }
                                            )
                                            .padding(1)

                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                    }

                                    if dependencies.count > 5 {
                                        Button(action: {
                                            productMembershipVisible.toggle()
                                        }, label: {
                                            HStack {
                                                Image(systemName: !productMembershipVisible ? "chevron.right" : "chevron.up")
                                                Text(!productMembershipVisible ? "Display \(dependencies.count - 5) more products" : "Display less products")
                                            }
                                        })
                                        .buttonStyle(.plain)
                                        .padding(.top, 4)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.05))
                                )
                                .padding(.leading, 16)
                            }
                        }


                        // MARK: - Products

                        if let dependencies = model.selectedTarget.productDependencies {
                            Button(action: {
                                productDepsSection.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: productDepsSection ? "chevron.down" : "chevron.right")
                                    Text("\(dependencies.count) product dependencies").bold().foregroundStyle(.secondary)
                                }
                            })
                            .buttonStyle(.plain)
                            .padding(.top, 4)

                            if productDepsSection {
                                VStack(alignment: .leading) {
                                    ForEach(Array(dependencies.prefix( productDependenciesVisible ? .max : 5)), id: \.self) { dep in
                                        HStack {
                                            LinkButton(
                                                source: dep,
                                                targetURL: .empty,
                                                iconName: targetIconWithName(dep),
                                                onClick: {
                                                    model.selectedProduct = model.products.first(where: { prod in prod.name == dep })
                                                }
                                            )
                                            .padding(1)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                    }

                                    if dependencies.count > 5 {
                                        Button(action: {
                                            productDependenciesVisible.toggle()
                                        }, label: {
                                            HStack {
                                                Image(systemName: !productDependenciesVisible ? "chevron.right" : "chevron.up")
                                                Text(!productDependenciesVisible ? "Display \(dependencies.count - 5) more dependencies" : "Display less dependencies")
                                            }
                                        })
                                        .buttonStyle(.plain)
                                        .padding(.top, 4)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.05))
                                )
                                .padding(.leading, 16)
                            }
                        }

                        // MARK: - Targets

                        if let dependencies = model.selectedTarget.targetDependencies {
                            Button(action: {
                                targetDepsSection.toggle()
                            }, label: {
                                HStack {
                                    Image(systemName: targetDepsSection ? "chevron.down" : "chevron.right")
                                    Text("\(dependencies.count) target dependencies").bold().foregroundStyle(.secondary)
                                }
                            })
                            .buttonStyle(.plain)
                            .padding(.top, 4)

                            if targetDepsSection {

                                VStack(alignment: .leading) {
                                    ForEach(Array(dependencies.prefix( targetDependenciesVisible ? .max : 5)), id: \.self) { dep in
                                        HStack {
                                            LinkButton(
                                                source: dep,
                                                targetURL: .empty,
                                                iconName: targetIconWithName(dep),
                                                onClick: {
                                                    if let selectedProduct = model.products.first(where: { prod in
                                                        prod.targets.contains(dep)
                                                    }) {
                                                        model.selectedProduct = selectedProduct
                                                        model.selectedTarget = model.package.targets.first(where: { t in t.name == dep })
                                                    }
                                                }
                                            )
                                            .padding(1)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity)
                                    }

                                    if dependencies.count > 5 {
                                        Button(action: {
                                            targetDependenciesVisible.toggle()
                                        }, label: {
                                            HStack {
                                                Image(systemName: !targetDependenciesVisible ? "chevron.right" : "chevron.up")
                                                Text(!targetDependenciesVisible ? "Display \(dependencies.count - 5) more dependencies" : "Display less dependencies")
                                            }
                                        })
                                        .buttonStyle(.plain)
                                        .padding(.top, 4)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.05))
                                )
                                .padding(.leading, 16)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding()
            }

            Spacer()
            Divider()
            HStack(alignment: .center) {
                Spacer()
                Text("\(model.selectedTarget.sources?.count ?? 0) source files")
                    .font(.headline)
                    .foregroundStyle(Color.secondary)
                Spacer()
            }
        }
        .padding(0)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
