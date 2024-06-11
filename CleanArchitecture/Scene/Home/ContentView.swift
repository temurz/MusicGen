//
//  ContentView.swift
//  CleanArchitecture
//
//  Created by Tuan Truong on 7/14/20.
//  Copyright © 2020 Tuan Truong. All rights reserved.
//

import SwiftUI
import Replicate
import AVFoundation
import CoreData
struct Base {
    static let token = "r8_fMQ8Yl8560PzcKbjaqfwP2S2wN1TLxC38zmHT"
}
private let client = Replicate.Client(token: "r8_fMQ8Yl8560PzcKbjaqfwP2S2wN1TLxC38zmHT")

class SoundManager : ObservableObject {
    var audioPlayer: AVPlayer?

    func playSound(url: URL){
        
        self.audioPlayer = AVPlayer(url: url)
        
    }
}

enum MusicGen: Predictable {
    struct Input: Codable {
        let prompt: String
        var duration: Int = 3
    }
    
    typealias Output = [URL]
    
    static var versionID: Model.Version.ID = "671ac645ce5e552cc63a54a2bbff63fcf798043055d2dac5fc9e36a837eedcfb"
    
    static var modelID: Model.ID = "meta/musicgen/stereo-large"
}

struct ContentView: View {
    @State private var prompt = ""
    @State private var duration = ""
    @State private var prediction: MusicGen.Prediction? = nil
    @State private var isTextFieldDisabled = false
    @State private var url: URL?
    @State private var isPresentedAlert = false
    
    @State private var player: AVPlayer?
    @State private var playerItem: AVPlayerItem?
    @State private var isPlaying = false
    @State private var totalTime: Double = .zero
    @State private var currentTime: Double = .zero
    
    func generate() async throws {
        let input = MusicGen.Input(prompt: prompt, duration: Int(duration) ?? 3)
        prediction = try await MusicGen.predict(with: client,
                                                 input: input)
        
        try await prediction?.wait(with: client)
    }
    
    func cancel() async throws {
        try await prediction?.cancel(with: client)
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                
                TextField("Enter a prompt to generate music",
                          text:$prompt)
                .disabled(isTextFieldDisabled)
                .submitLabel(.go)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .onSubmit {
                    if !prompt.isEmpty {
                        addToLocal(prompt: prompt)
                        Task {
                            try await generate()
                        }
                    }
                }
                if let url {
                    VStack {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.largeTitle)
                            .onTapGesture {
                                isPlaying ? stopAudio() : playAudio()
                            }
                        Slider(value: Binding(get: {
                            currentTime
                        }, set: { newValue in
                            seekAudio(to: newValue)
                        }), in: 0...totalTime)
                        HStack {
                            Text(timeString(time: currentTime))
                            Spacer()
                            Text(timeString(time: totalTime))
                        }
                        .padding(.horizontal)
                        ShareLink("Export", item: url)
                            .padding()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .onAppear {
                        isTextFieldDisabled = false
                        setupAudio()
                    }
                    .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
                        updateProgress()
                    }
                }
                if let prediction, url == nil {
                    
                    ZStack {
                        Color.clear
                            .aspectRatio(1.0, contentMode: .fit)
                        
                        switch prediction.status {
                        case .starting, .processing:
                            VStack{
                                ProgressView("Generating...")
                                    .padding(32)
                                    .onAppear {
                                        isTextFieldDisabled = true
                                        getUpdate(for: prediction.urls["get"])
                                    }
                                
                                Button("Cancel") {
                                    Task { try await cancel() }
                                }
                                
                            }
                        default:
                            VStack {}
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .padding()
            
        }
        .navigationTitle("Generate music")
        .navigationBarItems(trailing: Button(action: {
            isPresentedAlert = true
        }, label: {
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .foregroundStyle(.blue)
        }))
        .sheet(isPresented: $isPresentedAlert) {
            VStack {
                HStack {
                    Text("Duration")
                    Spacer()
                    TextField("10", text: $duration)
                        .keyboardType(.numberPad)
                        .submitLabel(.done)
                        .frame(width: 20, height: 16)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
                .padding()
                Button {
                    isPresentedAlert = false
                } label: {
                    Text("Done")
                        .foregroundStyle(.white)
                        .padding()
                        .background(.blue)
                        .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
            
        }
    }
    
    private func setupAudio() {
        let asset = AVAsset(url: url!)
        let playerItem = AVPlayerItem(asset: asset)
        self.playerItem = playerItem
        player = AVPlayer(playerItem: playerItem)
        
        Task {
            do {
                let duration = try await asset.load(.duration)
                totalTime = CMTimeGetSeconds(duration)
            } catch {
                print("Failed to load duration: \(error.localizedDescription)")
            }
        }
    }
    
    
    private func playAudio() {
        player?.play()
        isPlaying = true
    }
    
    private func stopAudio() {
        player?.pause()
        isPlaying = false
    }
    
    private func updateProgress() {
        guard let player = player, let currentItem = player.currentItem else { return }
        currentTime = CMTimeGetSeconds(currentItem.currentTime())
        if currentTime == totalTime, totalTime != 0.0 {
            isPlaying = false
            seekAudio(to: 0.0)
        }
    }
    
    private func seekAudio(to time: Double) {
        player?.seek(to: CMTime(seconds: time, preferredTimescale: 1))
    }

    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func getUpdate(for url: URL?) {
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            if let url {
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue( "Bearer \(Base.token)", forHTTPHeaderField: "Authorization")
                print("url found")
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    if let error {
                        print(error)
                    }
                    if let data {
                        if let output = try? JSONDecoder().decode(UpdateOutput.self, from: data) {
                            self.url = output.output
                            if output.status == "succeeded" {
                                timer.invalidate()
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    private func addToLocal(prompt: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newData = Row(context: context)
        newData.id = UUID()
        newData.prompt = prompt
        do {
            try context.save()
        } catch {
            print("error-Saving data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct UpdateOutput: Decodable {
    let status: String?
    let output: URL?
}
