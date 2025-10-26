//
//  HistoryItemView.swift
//  SmartRepair
//
//  Created by Rashika
//

import Foundation
import SwiftUI


struct HistoryItemView: View {
    let record: RepairRecord

    var body: some View {
        HStack(spacing: 12) {
            if let data = record.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(record.problemType ?? "Unknown")
                    .font(.headline)
                Text("Estimated Cost: $\(record.estimatedCost)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(record.date ?? Date(), style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}
