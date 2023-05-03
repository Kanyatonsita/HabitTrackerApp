//
//  SignInView.swift
//  HabitTrackerApp
//
//  Created by Kanyaton Somjit on 2023-04-21.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    @Binding var signedIn : Bool
    var auth = Auth.auth()
    
    var body: some View {
        Button(action: {
            auth.signInAnonymously { result, error in
                if let error = error {
                    print("error signing in \(error)")
                } else {
                    signedIn = true
                }
            }
        }){
            ZStack{
                Image("blackground")
                HStack{
                    Image(systemName: "person.circle")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.leading)
                    Text("Sign in")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding([.top, .bottom, .trailing])
                }
                .background(Color(red: 177/256, green: 112/256, blue: 54/256))
                .cornerRadius(40.0)
            }
        }
    }
}

//struct SignInView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignInView()
//    }
//}
