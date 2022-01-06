//
//  main.swift
//  RandomNumberProvider
//
//  Created by Brian Doyle on 1/5/22.
//

import Foundation

let filePath = "/tmp/prng-service.txt"

FileManager.default.createFile(
    atPath: filePath,
    contents: Data(),
    attributes: [
        .posixPermissions: 0o666
    ])

let fileHandle = FileHandle(forUpdatingAtPath: filePath)!
let dispatchSource = DispatchSource.makeFileSystemObjectSource(
    fileDescriptor: fileHandle.fileDescriptor,
    eventMask: .extend,
    queue: .main)

dispatchSource.setEventHandler {
    do {
        try fileHandle.seek(toOffset: 0)

        guard
            let inputData = try fileHandle.readToEnd(),
            let request = String(data: inputData, encoding: .utf8)
            else { return }

        if request == "run" {
            try fileHandle.truncate(atOffset: 0)

            let randomNumber = Int.random(in: 0..<1000)
            let response = "\(randomNumber)"
            let outputData = response.data(using: .utf8)!

            try fileHandle.write(contentsOf: outputData)
        }
    } catch {
        try? fileHandle.truncate(atOffset: 0)
    }
}

dispatchSource.resume()

RunLoop.main.run()
