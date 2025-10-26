//
//  AnalysisViewWrapper.swift
//  SmartRepair
//
//  Created by Rashika
//

import Foundation
import SwiftUI

struct AnalysisViewWrapper: View {
    let record: RepairRecord

    var body: some View {
        VStack(spacing: 12) {
            if let data = record.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .shadow(radius: 5)
            }
            Text("🔧 \(record.problemType ?? "Unknown")")
                .font(.title2.bold())
            Text("💰 Estimated Cost: $\(record.estimatedCost)")
                .font(.headline)
            Text("📈 Confidence: \(record.confidence ?? "-")")
           // Text("🛠️ \(record.recommendedAction ?? "-")")
            Text("📝 \(record.descriptionText ?? "-")")
            Text("⚡ Urgency: \(record.urgency ?? "-")")
            Text("🛠️ DIY Friendly: \(record.diyFriendly ?? true)")

        }
        .padding()
        .navigationTitle("Repair Details")
    }
}
