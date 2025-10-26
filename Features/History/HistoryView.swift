//
//  HistoryView.swift
//  SmartRepair
//
//  Created by Rashika
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var store: HistoryStore

    var body: some View {
        NavigationStack {
            List(store.records) { record in
                HistoryItemView(record: record)
            }
            .navigationTitle("Repair History")
            .toolbar {
                Button("Refresh") { store.fetchRecords() }
            }
        }
    }
}
