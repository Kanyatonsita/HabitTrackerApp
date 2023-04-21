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
        
        if let id = habit.id {
           habitRef.document(id).updateData(["done" : !habit.done])
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
                        let habit = try document.data(as : Habit.self)
                        self.habits.append(habit)
                    } catch {
                        print("Error reading from db")
                    }
                }
            }
        }
    }    
}
