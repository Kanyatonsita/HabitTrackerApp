//
//  ContentView.swift
//  HabitTrackerApp
//
//  Created by Kanyaton Somjit on 2023-04-20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var signedIn = false
    
    var body: some View {
        ZStack{
            Color(red: 15/256, green: 35/256, blue: 26/256)
                .ignoresSafeArea()
            
            if !signedIn {
                SignInView(signedIn: $signedIn)
            } else {
                HabitListView()
            }
        }
    }
}

struct RowView: View {
    let habit : Habit
    let vm : HabitListVM
    
    var body: some View {
        HStack {
            Text(habit.name)
            Spacer()
            Text(habit.streak == 0 ? "" : "\(habit.emoji ?? "")")
            Text(String(habit.streak))
            Button(action: {
                vm.toggle(habit: habit)
                vm.updateEmoji(habit: habit)
            }){
                Image(systemName: habit.done ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(Color.black)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
