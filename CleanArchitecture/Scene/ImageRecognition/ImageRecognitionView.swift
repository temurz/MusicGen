//
//  ImageRecognitionView.swift
//  CleanArchitecture
//
//  Created by Temur on 30/09/2024.
//  Copyright © 2024 Tuan Truong. All rights reserved.
//

import SwiftUI
import Vision
import UIKit
struct ImageRecognitionView: View {
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    @State var contents = ""
    @State var isAlertPresented = false
    var body: some View {
        VStack {
            Text("To recognize the content of the image, choose an image from the gallery and you will get the content!")
                .font(.headline)
                .lineLimit(Int.max)
                .multilineTextAlignment(.center)
                .padding()
            Button {
                self.showCamera.toggle()
            } label: {
                Text("Open gallery")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .fullScreenCover(isPresented: self.$showCamera) {
                accessCameraView(selectedImage: self.$selectedImage)
            }
            .onChange(of: selectedImage) { newValue in
                if let selectedImage {
                    getOutput(image: selectedImage)
                }
            }
            
            if !contents.isEmpty {
                
                HStack {
                    Text(contents)
                        .lineLimit(Int.max)
                        .padding()
                    Spacer()
                    Button {
                        copy()
                        isAlertPresented = true
                    } label: {
                        Image(systemName: "doc.on.doc")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding()
                    }
                }
                .background(Color.gray.opacity(0.3))
                .cornerRadius(12)
                .padding()
                
                
            }
            Spacer()
        }
        .alert(isPresented: $isAlertPresented) {
            Alert(title: Text("Copied!"), message: Text("Text copied to clipboard"), dismissButton: .none)
        }
        .padding(.all, 8)
        .navigationTitle("Recognize images")
    }
    
    private func copy() {
        UIPasteboard.general.string = contents
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isAlertPresented = false
        }
    }
    
    private func getOutput(image: UIImage) {
        do {
            try ImagePredictor().makePredictions(for: image,
                                                    completionHandler: imagePredictionHandler)
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }
    
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
//            updatePredictionLabel("No predictions. (Check console log.)")
            return
        }
        
        let formattedPredictions = formatPredictions(predictions)
        print(formattedPredictions)
//        let predictionString = formattedPredictions.joined(separator: "\n")
//        updatePredictionLabel(predictionString)
    }
    private func formatPredictions(_ predictions: [ImagePredictor.Prediction]) -> [String] {
        // Vision sorts the classifications in descending confidence order.
        let topPredictions: [String] = predictions.prefix(2).map { prediction in
            var name = prediction.classification

            // For classifications with more than one name, keep the one before the first comma.
            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

//            return "\(name) - \(prediction.confidencePercentage)%"
            return name
        }
        contents = topPredictions.joined(separator: ", ")
        return topPredictions
    }
}
