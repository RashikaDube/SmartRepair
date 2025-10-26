//
//  RepairEstimate.swift
//  SmartRepair
//
//  Created by Rashika
//

import Foundation
import FoundationModels

@Generable
struct RepairEstimate: Codable {
    let problemType: String
    let estimatedCost: Int
    let confidence: String
    let description: String
    let urgency: String
    let diyFriendly: Bool
    let recommendedAction: String
}
