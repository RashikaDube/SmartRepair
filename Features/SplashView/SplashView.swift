//
//  SplashView.swift
//  SmartRepair
//
//  Created by Rashika
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        if isActive {
            WelcomeView()
        } else {
            ZStack {
                Color("CreamBeige").ignoresSafeArea()
                VStack {
                    Image("AppLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                    Text("Smart Repair Estimator")
                        .font(.title.bold())
                        .foregroundColor(.black)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { isActive = true }
                }
            }
        }
    }
}
