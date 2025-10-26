//
//  ResultView.swift
//  SmartRepair
//
//  Created by Rashika
//

import SwiftUI

struct ResultView: View {
    let repairEstimate: RepairEstimate

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("🔧 \(repairEstimate.problemType)").font(.title2).bold()
            Text("💰 Est. Cost: $\(repairEstimate.estimatedCost)")
            Text("📈 Confidence: \(repairEstimate.confidence)")
            Text("📝 Description: \(repairEstimate.description)")
            Text("🛠️ Recommended Action: \(repairEstimate.recommendedAction)")
            Text("⚡ Urgency: \(repairEstimate.urgency)")
            Text("🛠️ DIY Friendly: \(repairEstimate.diyFriendly)")
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
        .padding()
    }
}
