//
//  EditNoteView.swift
//  NotesAppUsingCoreData
//
//  Created by Aya Irshaid on 16/09/2024.
//

import SwiftUI

struct EditNoteView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) private var dismiss
    
    @State var noteTitle: String = ""
    @State var noteMessageText: String = ""
    @State var note: Note?
    @State var isEditModeEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading
        ) {
            editView()
                .disabled(!isEditModeEnabled)
            Spacer()
        }
        .padding(.horizontal, 24.0)
        .background {
            Color.white
        }
        .toolbar {
            Button {
                withAnimation {
                    isEditModeEnabled.toggle()
                }
            } label: {
                Image(systemName: isEditModeEnabled ? "pencil" : "pencil.slash")
                    .contentTransition(.symbolEffect(.replace))
            }
        }
    }
    
    @ViewBuilder
    func editView() -> some View {
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
        if isEditModeEnabled {
            Button {
                updateNote(title: noteTitle, messageText: noteMessageText) {
                    dismiss()
                }
            } label: {
                Text("Done")
                    .padding(.horizontal, 50)
                    .padding(.vertical)
                    .foregroundColor(.white)
                    .background(.indigo)
                    .cornerRadius(10)
            }
            .transition(.scale)
        }
    }
}

private extension EditNoteView {
    func updateNote(title: String, messageText: String, _ clouser: () -> Void) {
        note?.title = title
        note?.message = messageText
        saveContext()
        clouser()
    }

    func saveContext() {
        if note?.changedValues().count == 0 {
            return
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("Error updating managed object context: \(error)")
        }
    }
}

#Preview {
    EditNoteView()
}

