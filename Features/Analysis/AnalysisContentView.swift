//
//  AnalysisContentView.swift
//  SmartRepair
//
//  Created by Rashika
//

import SwiftUI

struct AnalysisContentView: View {
    let image: UIImage
    let estimate: RepairEstimate
    @ObservedObject var historyStore: HistoryStore
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    @State private var showSavedAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
                // Preview Image
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("📊 Repair Analysis")
                        .font(.title2.bold())
                        .foregroundColor(.brown)
                        .padding(.bottom, 6)
                    
                    Text("🔧 \(estimate.problemType)")
                        .font(.headline)
                    
                    Text("💰 Est. Cost: $\(estimate.estimatedCost - 50) - $\(estimate.estimatedCost)")
                        .font(.subheadline)
                    
                    Text("📈 Confidence: \(estimate.confidence)")
                    Text("📝 Description: \(estimate.description)")
                    Text("⚡ Urgency: \(estimate.urgency)")
                    Text("🛠️ DIY Friendly: \(estimate.diyFriendly ? "Yes" : "No")")
                }
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(16)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                // Buttons Section
                HStack(spacing: 20) {
                    Button(action: saveToHistory) {
                        Label("Save", systemImage: "square.and.arrow.down")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.brown.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { showShareSheet = true }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.brown.opacity(0.6))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { dismiss() }) {
                        Label("Retake", systemImage: "arrow.clockwise")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.brown.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
        }
        .background(Color("CreamBeige").ignoresSafeArea())
        .sheet(isPresented: $showShareSheet) {
            ActivityView(activityItems: [image])
        }
        .alert("✅ Saved to History!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) {}
        }
    }
    
    // MARK: - Save Logic
    private func saveToHistory() {
        historyStore.addRecord(from: estimate, image: image)
        showSavedAlert = true
    }
}

// MARK: - Share Sheet Wrapper
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
