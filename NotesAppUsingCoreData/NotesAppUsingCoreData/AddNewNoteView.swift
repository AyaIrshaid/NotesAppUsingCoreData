//
//  AddNewNoteView.swift
//  NotesAppUsingCoreData
//
//  Created by Aya Irshaid on 15/04/2024.
//

import SwiftUI

struct AddNewNoteView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var noteTitle: String = ""
    @State private var noteMessageText: String = ""
    
    var body: some View {
        VStack(alignment: .leading
        ) {
            Text("Title:")
            TextEditor(text: $noteTitle)
                .foregroundStyle(.secondary)
                .frame(height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(.gray, lineWidth: 1.0)
                )
            Text("Message:")
            TextEditor(text: $noteMessageText)
                .foregroundStyle(.secondary)
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(.gray, lineWidth: 1.0)
                )
            Spacer()
        }
        .padding(.horizontal, 24.0)
        .background {
            Color.white
        }
        .toolbar {
            Button("Done") {
                saveNewNote(title: noteTitle, messageText: noteMessageText) {
                    dismiss()
                }
            }
        }
    }
}

private extension AddNewNoteView {
    func saveNewNote(title: String, messageText: String, _ clouser: () -> Void) {
        let newNote = Note(context: managedObjectContext)
        newNote.title = title
        newNote.message = messageText
        newNote.creationDate = .now
        
        saveContext()
        clouser()
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
    AddNewNoteView()
}
