//
//  main.swift
//  ImageProvider
//
//  Created by Brian Doyle on 1/5/22.
//

import Foundation

let fileManager = FileManager.default
let filePath = "/tmp/image-service.txt"
let imagesPath = "/Users/brian/Documents/Education/OSU/Classes/CS361 Software Engineering/Assignments/Assignment 2/CS361Assignment2/ImageProvider/images"
let directoryContents = (try? fileManager.contentsOfDirectory(atPath: imagesPath)) ?? []
let images = directoryContents.filter { $0.hasSuffix(".jpg") || $0.hasSuffix(".png") }.sorted()

fileManager.createFile(
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

        if var index = Int(request) {
            try fileHandle.truncate(atOffset: 0)

            index = index % images.count

            let response = imagesPath + "/" + images[index]
            let outputData = response.data(using: .utf8)!

            try fileHandle.write(contentsOf: outputData)
        }
    } catch {
        try? fileHandle.truncate(atOffset: 0)
    }
}

dispatchSource.resume()

RunLoop.main.run()
