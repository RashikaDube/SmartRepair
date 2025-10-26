//
//  SmartRepairApp.swift
//  SmartRepair
//
//  Created by Rashika
//

import SwiftUI

@main
struct SmartRepairApp: App {
    @StateObject private var historyStore = HistoryStore()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashView()
                    .environmentObject(historyStore)
            }
        }
    }
}
