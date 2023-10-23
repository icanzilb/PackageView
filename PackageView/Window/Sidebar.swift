//
//  Sidebar.swift
//  PackageView
//
//  Created by Marin Todorov on 10/22/23.
//

import SwiftUI

func iconName(forProductType: String) -> String {
    return switch forProductType {
    case "library": "building.columns.fill"
    case "executable": "figure.run"
    case "test": "testtube.2"
    case "macro": "camera.macro"
    default: "square"
    }
}

struct SidebarView: View {
    @EnvironmentObject var model: PackageModel

    var body: some View {
        if model.url != nil {
            VStack(alignment: .leading) {
                Text(model.url!.lastPathComponent.uppercased())
                    .font(.body.uppercaseSmallCaps().bold())
                    .foregroundStyle(.secondary)
                Divider()
                ScrollViewReader { reader in
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            ForEach(model.products) { product in
                                HStack(spacing: 4) {
                                    Image(systemName: iconName(forProductType: product.type.keys.first!))
                                        .renderingMode(.original)
                                        .opacity(model.selectedProduct == product ? 1.0 : 0.8  )
                                    
                                    Text(product.name)
                                        .lineLimit(1)
                                        .foregroundStyle(.primary)
                                        .bold()
                                        .opacity(model.selectedProduct == product ? 1.0 : 0.8  )
                                        .padding(2)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                                .id(product.id)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(model.selectedProduct == product ? .blue.opacity(0.3) : .clear)
                                })
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    model.selectedProduct = product
                                    model.selectedTarget = nil
                                }
                                .onChange(of: model.selectedProduct, perform: { product in
                                    reader.scrollTo(product.id)
                                })
                            }
                        }
                    }
                }
                
                
                if model.package.products.count == 0 {
                    Text("No products found")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                Divider()
                HStack(alignment: .center) {
                    Spacer()

                    if model.productFilter.isEmpty {
                        Text("\(model.package.products.count) products")
                            .font(.headline)
                            .foregroundStyle(Color.secondary)
                    } else {
                        Text("\(model.productFilter.count) filtered")
                            .font(.headline)
                            .foregroundStyle(Color.secondary)
                    }

                    Spacer()
                }
            }
            .padding(0)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

