//
//  ClientApp.swift
//  Client
//
//  Created by Brian Doyle on 1/5/22.
//

import SwiftUI

@main
struct ClientApp: App {
    @StateObject private var model = Model()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
                .frame(width: 360, height: 320, alignment: .center)
        }
    }
}
