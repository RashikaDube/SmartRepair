//
//  AnalysisView.swift
//  SmartRepair
//
//  Created by Rashika
//

import SwiftUI
import Combine

struct AnalysisView: View {
    @StateObject private var viewModel: AnalysisViewModel
    let image: UIImage
    @ObservedObject var historyStore: HistoryStore
    @Environment(\.dismiss) private var dismiss
    @State private var showShareSheet = false
    
    init(selectedImage: UIImage, historyStore: HistoryStore) {
        self.image = selectedImage
        let vm = AnalysisViewModel()
        vm.historyStore = historyStore
        _viewModel = StateObject(wrappedValue: vm)
        self.historyStore = historyStore
    }
    
    var body: some View {
        ZStack {
            Color("CreamBeige").ignoresSafeArea()
            
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView("Analyzing repair...")
                        .font(.headline)
                        .tint(.brown)
                } else if let estimate = viewModel.estimate {
                    ScrollView {
                        VStack(spacing: 15) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(16)
                                .shadow(radius: 5)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("📊 Repair Analysis")
                                    .font(.title.bold())
                                    .foregroundColor(.brown)
                                    .padding(.bottom, 4)
                                
                                Text("🔧 \(estimate.problemType)")
                                    .font(.headline)
                                Text("💰 Est. Cost: $\(estimate.estimatedCost - 50)–$\(estimate.estimatedCost)")
                                Text("📈 Confidence: \(estimate.confidence)")
                               // Text("🛠️ Recommended: \(estimate.recommendedAction)")
                                Text("📝 Description: \(estimate.description)")
                                Text("⚡ Urgency: \(estimate.urgency)")
                                Text("🧰 DIY Friendly: \(estimate.diyFriendly ? "Yes" : "No")")
                            }
                            .foregroundColor(.brown)
                            .padding()
                            .background(Color.white.opacity(0.6))
                            .cornerRadius(16)
                            .shadow(radius: 2)
                            .padding(.horizontal)
                            
                            // Action Buttons
                            HStack(spacing: 16) {
                                Button(action: {
                                    viewModel.saveToHistory(image: image)
                                }) {
                                    Label("Save", systemImage: "tray.and.arrow.down.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(ActionButtonStyle(color: .brown))
                                
                                Button(action: {
                                    showShareSheet = true
                                }) {
                                    Label("Share", systemImage: "square.and.arrow.up.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(ActionButtonStyle(color: .brown.opacity(0.8)))
                                
                                Button(action: {
                                    dismiss()
                                }) {
                                    Label("Retake", systemImage: "arrow.counterclockwise.circle.fill")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(ActionButtonStyle(color: .brown.opacity(0.6)))
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                        .padding(.bottom, 20)
                    }
                } else if let error = viewModel.error {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
        .task {
            await viewModel.analyze(image: image)
        }
        .sheet(isPresented: $showShareSheet) {
            if let estimate = viewModel.estimate {
                let summary = """
                🔧 \(estimate.problemType)
                💰 Cost: $\(estimate.estimatedCost)
                📈 Confidence: \(estimate.confidence)
                ⚡ Urgency: \(estimate.urgency)
                🧰 DIY Friendly: \(estimate.diyFriendly ? "Yes" : "No")
                """
                ActivityViewController(activityItems: [summary, image])
            }
        }
        .navigationTitle("Repair Analysis")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Button Style
struct ActionButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.bold())
            .padding()
            .background(color.opacity(configuration.isPressed ? 0.7 : 1))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 2)
    }
}

// MARK: - Share Sheet Helper
struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Extend ViewModel for Save
extension AnalysisViewModel {
    func saveToHistory(image: UIImage) {
        guard let estimate = estimate else { return }
        historyStore?.addRecord(from: estimate, image: image)
    }
}
