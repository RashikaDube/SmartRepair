//
//  AnalysisResultView.swift
//  SmartRepair
//
//  Created by Rashika
//

import SwiftUI

struct AnalysisResultView: View {
    let image: UIImage
    let estimate: RepairEstimate
    @ObservedObject var historyStore: HistoryStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image preview
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(15)
                    .shadow(radius: 5)

                // Repair Details
                VStack(alignment: .leading, spacing: 12) {
                    Text("🔧 \(estimate.problemType)")
                        .font(.title2)
                        .bold()

                    Text("💰 Est. Cost: $\(estimate.estimatedCost)-$\(estimate.estimatedCost * 2)") 
                        .font(.headline)

                    Text("📈 Confidence: \(estimate.confidence)")
                        .font(.subheadline)

                    Text("📝 Description:")
                        .font(.headline)
                    Text(estimate.description)
                        .font(.body)
                        .foregroundColor(.secondary)

                    Text("⚡ Urgency: \(estimate.urgency)")
                        .font(.subheadline)

                    Text("🛠️ DIY Friendly: \(estimate.diyFriendly ? "Yes" : "No")")
                        .font(.subheadline)
                }
                .padding()
                .background(Color("CreamBeige").opacity(0.5))
                .cornerRadius(12)
                .shadow(radius: 3)

                // Action Buttons
                HStack(spacing: 20) {
                    Button(action: {
                        historyStore.addRecord(from: estimate, image: image)
                    }) {
                        Text("Save")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brown.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        shareImage()
                    }) {
                        Text("Share")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brown.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        dismiss()
                    }) {
                        Text("Retake")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brown.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Repair Analysis")
        .background(Color("CreamBeige").ignoresSafeArea())
    }

    // MARK: - Share function
    private func shareImage() {
        let av = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(av, animated: true)
        }
    }
}
