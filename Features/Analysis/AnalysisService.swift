//
//  AnalysisService.swift
//  SmartRepair
//
//  Created by Rashika
//



import UIKit
import CoreML
import Vision

final class AnalysisService {
    private let model: VNCoreMLModel
    
    init() {
        do {
            let mlModel = try MobileNetV2(configuration: MLModelConfiguration()).model
            self.model = try VNCoreMLModel(for: mlModel)
        } catch {
            fatalError("Failed to load MobileNetV2 model: \(error)")
        }
    }

    func analyze(image: UIImage) async throws -> RepairEstimate {
        guard let ciImage = CIImage(image: image) else {
            throw NSError(domain: "Invalid image", code: 0)
        }

        // Prepare Core ML request
        let request = VNCoreMLRequest(model: model)
        request.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try handler.perform([request])

        guard let classification = request.results?.first as? VNClassificationObservation else {
            throw NSError(domain: "No classification result", code: 0)
        }

        let problemType = classification.identifier
        let confidence = classification.confidence

        let (estimatedCost, urgency, recommendedAction, description, diyFriendly) = mapRepairDetails(for: problemType, confidence: confidence)

        return RepairEstimate(
            problemType: problemType,
            estimatedCost: estimatedCost,
            confidence: String(format: "%.2f", confidence),
            description: description,
            urgency: urgency,
            diyFriendly: diyFriendly,
            recommendedAction: recommendedAction
        )
    }

    private func mapRepairDetails(for problemType: String, confidence: VNConfidence) -> (Int, String, String, String, Bool) {
        switch problemType.lowercased() {
        case "leaky faucet":
            return (150, "Medium", "Replace washer", "The faucet is leaking due to a worn-out washer.", true)
        case "broken window":
            return (300, "High", "Replace glass", "The window glass is cracked or shattered.", false)
        case "wall crack":
            return (200, "Medium", "Patch & paint", "Minor wall cracks detected; requires patching and repainting.", true)
        default:
            return (100, "Low", "Inspect manually", "The issue is detected but further inspection is recommended.", false)
        }
    }
}
