//
//  NoteDetailsView.swift
//  NotesAppUsingCoreData
//
//  Created by Aya Irshaid on 15/04/2024.
//

import SwiftUI

struct NoteDetailsView: View {
    let noteTtile: String
    let noteMessage: String

    var body: some View {
        Text(noteMessage)
            .navigationTitle(noteTtile)
    }
}

#Preview {
    NoteDetailsView(noteTtile: "NoteTitle", noteMessage: "NoteMessage")
}
