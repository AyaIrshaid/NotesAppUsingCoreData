//
//  NoteListModel.swift
//  NotesAppUsingCoreData
//
//  Created by Aya Irshaid on 27/09/2024.
//

import CoreData
import Foundation

class NoteListModel: ObservableObject {
    var managedObjectContext: NSManagedObjectContext

    @Published var notes: [Note] = []

    init(_ managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func fetchNotes() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let sortDescriptors = [NSSortDescriptor(keyPath: \Note.creationDate, ascending: false)]
        request.sortDescriptors = sortDescriptors
        fetchNotes(with: request)
    }

    func searchForNote(with text: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        let sortDescriptors = [NSSortDescriptor(keyPath: \Note.creationDate, ascending: false)]
        let predicate = text.isEmpty ? nil :NSPredicate(format: "title CONTAINS %@", text)
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        fetchNotes(with: request)
    }

    func fetchNotes(with request: NSFetchRequest<NSFetchRequestResult>) {
        do {
            notes = try managedObjectContext.fetch(request) as! [Note]
        }
        catch {
            preconditionFailure("Failed to fetch Notes")
        }
    }

    func deleteNote(_ note: Note) {
        managedObjectContext.delete(note)
        saveContext()
    }

    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}
