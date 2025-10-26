//
//  HistoryStore.swift
//  SmartRepair
//
//  Created by Rashika
//

import Foundation
import CoreData
import UIKit
import SwiftUI
import Combine

@MainActor
class HistoryStore: ObservableObject {
    let container: NSPersistentContainer
    @Published var records: [RepairRecord] = []

    init() {
        container = NSPersistentContainer(name: "SmartRepairModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
        fetchRecords()
    }

    func fetchRecords() {
        let request: NSFetchRequest<RepairRecord> = RepairRecord.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            records = try container.viewContext.fetch(request)
            print("Fetched records:", records.count)
        } catch {
            print("Failed to fetch records:", error)
        }
    }

    func addRecord(from estimate: RepairEstimate, image: UIImage) {
        let record = RepairRecord(context: container.viewContext)
        record.id = UUID()
        record.problemType = estimate.problemType
        record.estimatedCost = Int64(estimate.estimatedCost)
        record.confidence = estimate.confidence
        record.urgency = estimate.urgency
        record.recommendedAction = estimate.recommendedAction
        record.descriptionText = estimate.description
        record.diyFriendly = estimate.diyFriendly
        record.date = Date()
        record.imageData = image.jpegData(compressionQuality: 0.8)
        
        print("Adding record:", record.problemType ?? "Unknown", record.estimatedCost)

        save()
    }

    private func save() {
        do {
            try container.viewContext.save()
            fetchRecords()
            print("Saved successfully. Total records:", records.count)
        } catch {
            print("Failed to save record:", error)
        }
    }
}
