//
//  TokuAruApp.swift
//  TokuAru
//
//  Created by 阿部大輔 on 2023/11/08.
//

import SwiftUI

@main
struct TokuAruApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
