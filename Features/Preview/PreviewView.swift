//
//  PreviewView.swift
//  SmartRepair
//
//  Created by Rashika
//

import SwiftUI

struct PreviewView: View {
    let image: UIImage
    @State private var showAnalysis = false
    @State private var selectedImage: UIImage?
    @StateObject private var historyStore = HistoryStore()


    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .padding()

                    if let image = selectedImage {
                        NavigationLink(
                            destination: AnalysisView(
                                selectedImage: selectedImage!,
                                historyStore: historyStore
                            ),
                            isActive: $showAnalysis
                        ) {
                            EmptyView()
                        }
                    }


                    Button(action: {
                        showAnalysis = true   
                    }) {
                        Text("Done")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
