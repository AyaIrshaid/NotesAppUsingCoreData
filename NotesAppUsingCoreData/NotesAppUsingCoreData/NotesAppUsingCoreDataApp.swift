//
//  NotesAppUsingCoreDataApp.swift
//  NotesAppUsingCoreData
//
//  Created by Aya Irshaid on 15/04/2024.
//

import SwiftUI
import CoreData

var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Notes")
    container.loadPersistentStores { _, error in
        if let error = error as NSError? {
            preconditionFailure("Unresolved error \(error), \(error.userInfo)")
        }
    }
    return container
}()

@main
struct NotesAppUsingCoreDataApp: App {
    private let context = persistentContainer.viewContext
    
    var body: some Scene {
        WindowGroup {
            NoteListView().environment(\.managedObjectContext, context)
        }
    }
}
