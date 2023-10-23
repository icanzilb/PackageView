//
//  PackageModel.swift
//  PackageView
//
//  Created by Marin Todorov on 10/22/23.
//

import Foundation

class PackageModel: ObservableObject {
    @Published var package: PackageData!
    @Published var url: URL?

    @Published var selectedProduct: PackageData.Product! {
        didSet {
            productFilter = []
        }
    }
    @Published var selectedTarget: PackageData.Target!

    var products: [PackageData.Product] {
        productFilter.isEmpty ? package.products : package.products.filter({ product in
            productFilter.contains(product.name)
        })
    }

    @Published var productFilter = Set<String>()

    init() {

    }

    @Published var isLoading = false

    @discardableResult
    func loadPackage(at url: URL) throws -> PackageData {
        isLoading = true

        self.url = nil
        defer { isLoading = false }

        let jsonData = try loadPackageJSON(forPackageAt: url)
        let packageData = try JSONDecoder().decode(PackageData.self, from: jsonData)

        self.url = url
        package = packageData

        selectedProduct = package.products.first

        return packageData
    }

    func loadPackageJSON(forPackageAt url: URL) throws -> Data {
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = [
            "swift",
            "package",
            "describe",
            "--package-path",
            "\(url.path)",
            "--type=json"
        ]
        print("\(process.launchPath!) \(process.arguments!.joined(separator: " "))")

        let outputPipe = Pipe()
        process.standardOutput = outputPipe

        let errorPipe = Pipe()
        process.standardError = errorPipe

        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == EXIT_SUCCESS else {
            let error = String(data: errorPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
            throw ModelError(message: error?.trimmingCharacters(in: .newlines) ?? "unknown error")
        }

        return outputPipe.fileHandleForReading.readDataToEndOfFile()
    }

    struct ModelError: Error {
        let message: String
    }

    func absolutePathFor(relativePath path: String) -> URL {
        return (url ?? .empty).appendingPathComponent(path)
    }

    func absolutePathInTargetFor(relativePath path: String) -> URL {
        return (url ?? .empty)
            .appendingPathComponent(selectedTarget.path)
            .appendingPathComponent(path)
    }

    func target(withName name: String) -> PackageData.Target? {
        return package.targets.first(where: { $0.name == name })
    }
}
