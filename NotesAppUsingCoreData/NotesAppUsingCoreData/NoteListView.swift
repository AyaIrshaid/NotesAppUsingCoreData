//
//  NoteListView.swift
//  NotesAppUsingCoreData
//
//  Created by Aya Irshaid on 15/04/2024.
//

import CoreData
import SwiftUI

struct NoteListView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Note.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \Note.creationDate, ascending: false)])
    var notes: FetchedResults<Note>
    
    @State private var showShareSheet = false
    @State private var searchText = ""
    @State private var sharedNote: Note?

    let palette = Image(systemName: "list.bullet.circle")
        .symbolRenderingMode(.multicolor)

    var body: some View {
        NavigationView {
            List {
                ForEach(notes, id: \.id) { note in
                    NavigationLink(destination: NoteDetailsView(noteTtile: note.title ?? "", noteMessage: note.message ?? "")) {
                        VStack(alignment: .leading) {
                            Text("\(Text(palette)) \(note.title ?? "")")
                                .foregroundColor(.blue)
                                .font(.title)
                            Text((note.creationDate ?? .now).returnFormattedDate())
                                .foregroundColor(.gray)
                                .font(.title3)
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button {
                                self.sharedNote = note
                                self.showShareSheet = true
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            .tint(.purple)

                            Button(role: .destructive) {
                                deleteNote(note)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.pink)
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { _, newValue in
                notes.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "title CONTAINS %@", newValue)
            }
            .sheet(isPresented: $showShareSheet, content: {
                ShareSheet(activityItems: [sharedNote?.message as Any])
            })
            .navigationTitle("Notes")
            .toolbar {
                NavigationLink(destination: AddNewNoteView()) {
                    Label("", systemImage: "plus")
                }
            }
        }
    }
}

private extension NoteListView {
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

#Preview {
    NoteListView()
}
