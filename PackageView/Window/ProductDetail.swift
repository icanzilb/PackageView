//
//  ProductDetail.swift
//  PackageView
//
//  Created by Marin Todorov on 10/22/23.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var model: PackageModel

    func targetsForProduct(_ product: PackageData.Product) -> [PackageData.Target] {
        return model
            .selectedProduct
            .targets
            .compactMap { targetName -> PackageData.Target? in
                return model.package.targets.first(where: { t in
                    t.name == targetName
                })
            }
    }

    @State var targets = [PackageData.Target]()

    var body: some View {
        VStack(alignment: .leading) {
            Text(model.selectedProduct.name.uppercased())
                .font(.body.uppercaseSmallCaps().bold())
                .foregroundStyle(.secondary)
            Divider()

            ScrollViewReader { reader in
                ScrollView(.vertical) {
                    ForEach(targets) { target in
                        HStack(spacing: 4) {
                            Image(systemName: iconName(forProductType: target.type))
                                .renderingMode(.original)

                            Text(target.name)
                                .lineLimit(1)
                                .opacity(model.selectedTarget == target ? 1.0 : 0.8 )
                                .padding(2)

                            Spacer()
                        }
                        .padding(.vertical, 4)
                        .id(target.id)
                        .padding(.horizontal, 4)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(model.selectedTarget == target ? .blue.opacity(0.3) : .clear)
                        })
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            model.selectedTarget = target
                        }
                    }
                }
            }

            if targets.count == 0 {
                Text("No targets found")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }

            Spacer()
            Divider()
            HStack(alignment: .center) {
                Spacer()
                Text("\(targets.count) targets")
                    .font(.headline)
                    .foregroundStyle(Color.secondary)
                Spacer()
            }

        }
        .padding(0)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.05))

        .task {
            targets = targetsForProduct(model.selectedProduct)
            model.selectedTarget = targets.first
        }
        .onReceive(model.$selectedProduct, perform: { _ in
            targets = targetsForProduct(model.selectedProduct)
            model.selectedTarget = targets.first
        })
    }
}


