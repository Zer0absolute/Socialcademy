//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Maël Colomé on 18/07/2025.
//

import SwiftUI
import Firebase

@main
struct SocialcademyApp: App {
    init() {
        FirebaseApp.configure()
    }
  
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
