//
//  AnalysisViewModel.swift
//  SmartRepair
//
//  Created by Rashika
//

import Foundation
import UIKit
import Combine

@MainActor
final class AnalysisViewModel: ObservableObject {
    @Published var estimate: RepairEstimate?
    @Published var isLoading = false
    @Published var error: String?

    let service = AnalysisService()
    var historyStore: HistoryStore? // inject shared store

    func analyze(image: UIImage) async {
        isLoading = true
        do {
            let result = try await service.analyze(image: image)
            estimate = result

            // Save to history
            historyStore?.addRecord(from: result, image: image)
        } catch {
            self.error = "⚠️ \(error.localizedDescription)"
        }
        isLoading = false
    }
}
