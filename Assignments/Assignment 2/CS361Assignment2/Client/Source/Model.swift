//
//  Model.swift
//  Client
//
//  Created by Brian Doyle on 1/6/22.
//

import SwiftUI

final class Model: ObservableObject {
    @Published private(set) var image = Image("clear")

    private let imageServiceHandle: FileHandle
    private let imageServiceSource: DispatchSourceFileSystemObject
    private let randomNumberServiceHandle: FileHandle
    private let randomNumberServiceSource: DispatchSourceFileSystemObject

    init() {
        let rootDirectory = "/tmp/"
        let imageServicePath = rootDirectory + "image-service.txt"
        let randomNumberServicePath = rootDirectory + "prng-service.txt"

        imageServiceHandle = FileHandle(forUpdatingAtPath: imageServicePath)!
        imageServiceSource = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: imageServiceHandle.fileDescriptor,
            eventMask: .extend,
            queue: .main)
        randomNumberServiceHandle = FileHandle(forUpdatingAtPath: randomNumberServicePath)!
        randomNumberServiceSource = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: randomNumberServiceHandle.fileDescriptor,
            eventMask: .extend,
            queue: .main)

        imageServiceSource.setEventHandler {
            do {
                try self.imageServiceHandle.seek(toOffset: 0)

                guard
                    let inputData = try self.imageServiceHandle.readToEnd(),
                    let request = String(data: inputData, encoding: .utf8)
                    else { return }
                
                if request.hasPrefix("/") {
                    self.setImage(request)
                }
            } catch { }
        }

        randomNumberServiceSource.setEventHandler {
            do {
                try self.randomNumberServiceHandle.seek(toOffset: 0)

                guard
                    let inputData = try self.randomNumberServiceHandle.readToEnd(),
                    let request = String(data: inputData, encoding: .utf8)
                    else { return }

                if let value = Int(request) {
                    try? self.imageServiceHandle.truncate(atOffset: 0)
                    try? self.imageServiceHandle.write(contentsOf: "\(value)".data(using: .utf8)!)
                }
            } catch { }
        }

        imageServiceSource.resume()
        randomNumberServiceSource.resume()
    }

    func runRandomNumberService() {
        try? randomNumberServiceHandle.truncate(atOffset: 0)
        try? randomNumberServiceHandle.write(contentsOf: "run".data(using: .utf8)!)
    }

    func setImage(_ path: String) {
        let url = URL(fileURLWithPath: path)

        guard let nsImage = NSImage(contentsOf: url) else { return }

        image = Image(nsImage: nsImage)
    }
}
