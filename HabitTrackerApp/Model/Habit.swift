//
//  Habit.swift
//  HabitTrackerApp
//
//  Created by Kanyaton Somjit on 2023-04-21.
//

import Foundation
import FirebaseFirestoreSwift

struct Habit : Codable, Identifiable {

    @DocumentID var id : String?
    var name : String
    var done : Bool = false
    var latest : Date?
    var streak : Int = 0
    var emoji : String?
}
