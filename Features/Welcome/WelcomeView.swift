//
//  WelcomeView.swift
//  SmartRepair
//
//  Created by Rashika
//


import SwiftUI
import PhotosUI

struct WelcomeView: View {
    @StateObject private var historyStore = HistoryStore()
    @State private var showCamera = false
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showAnalysis = false
    
    // Cream-Beige Background
    let backgroundColor = Color("CreamBeige")
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                backgroundColor.ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // MARK: - Header
                    VStack(spacing: 10) {
                        Text("🏠 Smart Repair Estimator")
                            .font(.system(size: 20, weight: .bold))
                        Text("Take a photo of any home repair and get an instant cost estimate using AI")
                            .font(.system(size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                    }
                    
                    // MARK: - Image / Placeholder
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.7))
                            .frame(height: 300)
                            .shadow(radius: 5)
                        
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 280)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        } else {
                            VStack(spacing: 15) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 80)
                                    .foregroundColor(.gray)
                                Text("No Image Selected")
                                    .foregroundColor(.gray)
                                    .font(.subheadline)
                            }
                        }
                    }
                    
                    // MARK: - Action Buttons
                    HStack(spacing: 20) {
                        Button(action: { showCamera = true }) {
                            Label("Camera", systemImage: "camera.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(BeigeButtonStyle())
                        
                        PhotosPicker(selection: $photoPickerItem, matching: .images, photoLibrary: .shared()) {
                            Label("Gallery", systemImage: "photo.on.rectangle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(BeigeButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Change Image
                    if selectedImage != nil {
                        Button("Change Image") {
                            selectedImage = nil
                        }
                        .foregroundColor(.red)
                        .padding(.top, 5)
                    }
                    
                    // MARK: - Navigation Links
                    if let img = selectedImage {
                        NavigationLink(
                            destination: AnalysisView(selectedImage: img, historyStore: historyStore),
                            isActive: $showAnalysis
                        ) { EmptyView() }
                    }
                    
                    NavigationLink(
                        destination: HistoryView(store: historyStore),
                        label: {
                            Text("View History")
                                .font(.headline)
                                .foregroundColor(.brown)
                                .padding(.top, 20)
                        }
                    )
                    
                    Spacer()
                }
                .padding()
            }
            .onChange(of: photoPickerItem) { item in
                Task {
                    guard let data = try? await item?.loadTransferable(type: Data.self),
                          let uiImage = UIImage(data: data) else { return }
                    selectedImage = uiImage
                }
            }
            .onChange(of: selectedImage) { image in
                if image != nil { showAnalysis = true }
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraPickerView(selectedImage: $selectedImage)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

// MARK: - Beige Button Style
struct BeigeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.white.opacity(0.8))
            .foregroundColor(.brown)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
