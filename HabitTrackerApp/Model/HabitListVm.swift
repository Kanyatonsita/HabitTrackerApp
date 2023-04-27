//
//  HabitListVm.swift
//  HabitTrackerApp
//
//  Created by Kanyaton Somjit on 2023-04-21.
//

import Foundation
import Firebase

class HabitListVM : ObservableObject {
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    let date = Date()
    
    @Published var habits = [Habit]()
    
    func delete(index: Int) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = habits[index]
        if let id = habit.id {
            habitRef.document(id).delete()
        }
    }
    
    func toggle(habit: Habit) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        let date = Date()
        
        if let id = habit.id {
            habitRef.document(id).updateData(["done" : !habit.done])
            
            if habit.done == false{
                let newStreak = habit.streak + 1
                if habit.latest != date {
                    habitRef.document(id).updateData(["latest" : date, "streak" : newStreak])
                }
            }
        }
    }
    
    func saveToFirestore(habitName: String) {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        let habit = Habit(name: habitName)
        
        do {
             try habitRef.addDocument(from: habit)
        } catch {
            print("Error saving to db")
        }
    }
    
    func listenToFirestore() {
        guard let user = auth.currentUser else {return}
        let habitRef = db.collection("users").document(user.uid).collection("habits")
        
        habitRef.addSnapshotListener() {
            snapshot, err in
            
            guard let snapshot = snapshot else {return}
            
            if let err = err {
                print("error getting document \(err)")
            } else {
                self.habits.removeAll()
                for document in snapshot.documents {
                    do {
                        var habit = try document.data(as : Habit.self)
                        
                        let calendar = Calendar.current
                        if calendar.isDate(habit.latest ?? Date(), inSameDayAs: self.date) {
                            habit.done = true
                        } else {
                            habit.done = false
                        }
                        
                        self.habits.append(habit)
                    } catch {
                        print("Error reading from db")
                    }
                }
            }
        }
    }    
}


//func resetToggle(habit: Habit) {
//        guard let user = Auth.auth().currentUser, let habitId = habit.id else { return }
//
//        let habitRef = Firestore.firestore().collection("users").document(user.uid).collection("habits").document(habitId)
//        habitRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                let data = document.data()
//                if let dateTracker = data?["dateTracker"] as? [Timestamp] {
//                    let today = Date()
//                    let calendar = Calendar.current
//                    if !dateTracker.contains(where: { calendar.isDate($0.dateValue(), inSameDayAs: today) }){
//                        habitRef.updateData(["done" : false])}
//                }
//                }
//            }
//
//        }
