//
//  NewDateFormatter.swift
//  NotesAppUsingCoreData
//
//  Created by Aya Irshaid on 15/04/2024.
//

import UIKit

struct NewDateFormatter {
    static let shared = NewDateFormatter()

    var dateFormatter: DateFormatter {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        return dateformatter
    }

    func returnFormattedStringForTime(from dateTime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.locale = Locale(identifier: "en_JO")
        return dateFormatter.string(from: dateTime)
    }

    func returnFormattedStringForDate(from dateTime: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_JO")
        return dateFormatter.string(from: dateTime)
    }
}

extension Date {
    func returnFormattedDate() -> String {
        var formattedDate = ""
        let calendar = Calendar(identifier: .gregorian)
        if calendar.isDateInToday(self) {
            formattedDate = NewDateFormatter.shared.returnFormattedStringForTime(from: self)
        } else if calendar.isDateInYesterday(self) {
            formattedDate = "Yesterday"
        } else {
            formattedDate = NewDateFormatter.shared.returnFormattedStringForDate(from: self)
        }
        return formattedDate
    }
}
