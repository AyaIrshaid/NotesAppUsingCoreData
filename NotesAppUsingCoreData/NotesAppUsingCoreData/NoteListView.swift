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
    @State private var shouldShowConfirmDeleteSheet: Bool = false
    @State private var sheetContentHeight: CGFloat = UIScreen.main.bounds.height
    @State private var selectedNoteTitle: String?
    @State private var selectedNoteMessage: String?

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

                            Button {
                                if !shouldShowConfirmDeleteSheet {
                                    selectedNoteTitle = note.title ?? ""
                                    selectedNoteMessage = note.message ?? ""
                                    shouldShowConfirmDeleteSheet = true
                                }
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                            .tint(.pink)
                        }
                        .sheet(isPresented: $shouldShowConfirmDeleteSheet) {
                            confirmDelete()
                                .presentationDetents([.height(sheetContentHeight)])
                                .presentationCornerRadius(24.0)
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear
                                            .onAppear {
                                                sheetContentHeight = geometry.size.height
                                            }
                                            .onChange(of: geometry.size.height) { newHeight in
                                                sheetContentHeight = newHeight
                                            }
                                    }
                                )
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

extension NoteListView {
    func confirmDelete() -> some View {
        VStack(spacing: 16.0) {
            Text("Are you sure you want to delete this note?")
                .font(.headline)
                .padding(.top, 24.0)
            if let text = selectedNoteMessage {
                Text(text)
                    .font(.body)
            }
            HStack(spacing: 16.0) {
                Button {
                    clearSelectedNote()
                } label: {
                    Text("Cancel")
                        .font(.body)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 8.0)
                        .padding(.horizontal, 16.0)
                }
                .background(
                    Color.gray
                        .cornerRadius(24.0)
                )
                Button {
                    clearSelectedNote()
                } label: {
                    Text("Delete")
                        .font(.body)
                        .foregroundColor(Color.white)
                        .padding(.vertical, 8.0)
                        .padding(.horizontal, 16.0)
                }
                .background(
                    Color.pink
                        .cornerRadius(24.0)
                )
            }
        }
        .padding(16.0)
    }

    private func clearSelectedNote() {
        selectedNoteTitle = nil
        selectedNoteMessage = nil
        self.shouldShowConfirmDeleteSheet = false
    }
}

#Preview {
    NoteListView(noteListModel: NoteListModel(persistentContainer.viewContext))
}
