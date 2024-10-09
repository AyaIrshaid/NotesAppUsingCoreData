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
    @StateObject var noteListModel: NoteListModel
    
    @State private var showShareSheet = false
    @State private var searchText = ""
    @State private var sharedNote: Note?
    @State private var selectedNote: Note?

    let palette = Image(systemName: "list.bullet.circle")
        .symbolRenderingMode(.multicolor)

    var body: some View {
        NavigationStack {
            List {
                ForEach(noteListModel.notes, id: \.id) { note in
                    NavigationLink(destination:
                                    EditNoteView(
                                        noteTitle: note.title ?? "",
                                        noteMessageText: note.message ?? "",
                                        note: note
                                    )) {
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
                                sharedNote = note
                                self.showShareSheet = true
                            } label: {
                                Label("Share", systemImage: "square.and.arrow.up")
                            }
                            .tint(.purple)

                            Button(role: .destructive) {
                                noteListModel.deleteNote(note)
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
                noteListModel.searchForNote(with: newValue)
            }
            .sheet(isPresented: $showShareSheet, content: {
                ShareSheet(activityItems: [sharedNote?.message as Any])
            })
            .navigationTitle("Notes")
            .navigationBarItems(trailing: NavigationLink(destination: AddNewNoteView()) {
                Label("", systemImage: "plus")
            })
            .task {
                noteListModel.fetchNotes()
            }
        }
    }
}

#Preview {
    NoteListView(noteListModel: NoteListModel(persistentContainer.viewContext))
}
