//
//  MintView.swift
//  IPFSTest
//
//  Created by Bryan Albert on 9/18/22.
//

import SwiftUI
import Photos
import IPFSKit
import AVKit
import AVFoundation

struct MintView: View {
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var videoURL: String?
    // @State private var videoData: Data?
    @State private var image: Image?
    @State private var ipfsToggle = false
    @State private var isLoading = false
    @State private var imageIsPicked = false
    @State private var alertIsPresenting = false
    @State private var uriString = ""
    @State private var textString = ""
    @State private var toMintAlert = false
    @State private var successAlert = false
    @State var tap1 = false
    @State var tap2 = false
    
    let projectId = "PROJECT-ID"
    let secret = "SECRET"
    
    var body: some View {
        VStack() {
            Spacer(minLength: 50)
//            image?
//                .resizable()
//                .scaledToFit()
//                .border(.gray, width: 4)
//                .cornerRadius(6)
            if let convertedURL = URL(string: self.videoURL ?? "") {
                VideoPlayer(player: AVPlayer(url: convertedURL))
                    .frame(width: 350)
            }
            HStack() {
                Button("Choose Image") {
                    tap1 = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        tap1 = false
                        showingImagePicker = true
                    }
                }
                // .buttonStyle(MyButtonStyle())
                .padding()
                .onChange(of: inputImage) { _ in
                    loadImage()
                }
                .alert(isPresented: $successAlert) {
                    Alert(title: Text("Success!"), message: Text("The URL has been copied to your clipboard."))
                }
                .buttonStyle(MyButtonStyle())
                .scaleEffect(tap1 ? 1.2 : 1)
                .animation(.spring(response: 0.2, dampingFraction: 0.6))
                .disabled(isLoading)
         
                Button {
                    // ipfsToggle.toggle()
                    // isLoading.toggle()
                    tap2 = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        tap2 = false
                        toMintAlert.toggle()
                    }
                } label: {
                    Text("Add to IPFS")
                }
                .buttonStyle(MyButtonStyle())
                .scaleEffect(tap2 ? 1.2 : 1)
                .animation(.spring(response: 0.2, dampingFraction: 0.6))
                .disabled(isLoading)
//                .onChange(of: ipfsToggle) { _ in
//                    ipfsAdd(fileData: inputImage?.pngData()) { cid, error in
//                    // ipfsAdd(fileData: videoData) { cid, error in
//                        if let error = error {
//                            print(error)
//                            isLoading.toggle()
//                        } else {
//                            print("Success: ", cid!)
//                            uriString = cid!
//                            isLoading.toggle()
//                        }
//                    }
//                }
                .sheet(isPresented: $showingImagePicker) {
                    VideoPicker(videoURL: $videoURL)
                    // ImagePicker(image: $inputImage)
                }
                .alert(isPresented: $toMintAlert) {
                    Alert(title: Text("Are you sure?"), message: Text("This will now become public domain."), primaryButton: .destructive(Text("Cancel"), action: {
                        return
                    }) , secondaryButton: .default(Text("Mint"), action: {
                        isLoading = true
//                        ipfsAdd(fileData: inputImage?.pngData()) { cid, error in
//                        // ipfsAdd(fileData: videoData) { cid, error in
//                            if let error = error {
//                                print(error)
//                                isLoading = false
//                            } else {
//                                print("Success: ", cid!)
//                                uriString = cid!
//                                let url = urlFormatter(uri: uriString)
//                                let pasteboard = UIPasteboard.general
//                                pasteboard.string = url
//                                isLoading = false
//                                successAlert.toggle()
//                            }
//                        }
                        ipfsAddVideo(url: videoURL) { res, error in
                            if let error = error {
                                print(error)
                            } else {
                                let pasteboard = UIPasteboard.general
                                pasteboard.string = urlFormatter(uri: res!)
                                isLoading = false
                                successAlert.toggle()
                            }
                        }
                    }))
                }
            }
            if isLoading {
                ProgressView()
            }
            Spacer(minLength: 50)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        imageIsPicked.toggle()
    }
    
    func ipfsAdd(fileData: Data?, completion: @escaping (String?, Error?) -> Void) {
        isLoading = true
        let client = try? IPFSClient.init(host: "ipfs.infura.io", port: 5001, ssl: true, id: self.projectId, secret: self.secret)
        if let fileData = fileData {
            do {
                try client?.add(fileData) { nodes in
                    /// TODO: Add pin code here
                    let ipfsCID = (nodes.first?.name)!
                    let uri = "ipfs://" + ipfsCID
                    completion(uri, nil)
                }
            } catch let error {
                GraniteLogger.info("error adding new image:\n\(error)", .expedition, focus: true)
            }
        }
        else {
            alertIsPresenting.toggle()
            isLoading = false
        }
    }
    
    func ipfsAddVideo(url: String?, completion: @escaping (String?, Error?) -> Void) {
        isLoading = true
//        var request = URLRequest(url: URL(string: "https://ipfs.infura.io:5001/api/v0/")!)
//        request.httpMethod = "POST"
//        //set the other header variables here using
//        let auth = "\(self.projectId):\(self.secret)".data(using: .utf8)!.base64EncodedString()
//        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        let fileToUpload = documentsDirectory?.appendingPathComponent(url!)
        let fileData = try! Data(contentsOf: URL(string: url!)!)
        videoFormatter(data: fileData) { string, error in
            if let error = error {
                print(error)
            } else {
                let client = try? IPFSClient.init(host: "ipfs.infura.io", port: 5001, ssl: true, id: self.projectId, secret: self.secret)
                
                    do {
                        try client?.add(Data(contentsOf: URL(string: string!)!)) { nodes in
                            /// TODO: Add pin code here
                            let ipfsCID = (nodes.first?.name)!
                            let uri = "ipfs://" + ipfsCID
                            completion(uri, nil)
                        }
                    } catch let error {
                        GraniteLogger.info("error adding new image:\n\(error)", .expedition, focus: true)
                    }
            }
        }
        
//        let uploadTask = URLSession.shared.uploadTask(with: request, fromFile: fileToUpload!) {data, response, error in
//        //get some information from the server when the file has been uploaded
//            completion(String(decoding: data!, as: UTF8.self), nil)
//        }
//        uploadTask.resume()
    }
    
    func urlFormatter(uri: String) -> String {
        let url = uri.replacingOccurrences(of: "ipfs://", with: "https://fastload.infura-ipfs.io/ipfs/")
        return url
    }
    
    func videoFormatter(data: Data, completion: @escaping (String?, Error?) -> Void) {
        let preset = AVAssetExportPresetHighestQuality
        let newFileType = AVFileType.mp4
        let asset = data.getAVAsset()
        // let directory = FileManager.default.temporaryDirectory
        // let newFileName = "\(NSUUID().uuidString).mp4"
        // let fullURL = directory.appendingPathComponent(newFileName)
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        let filePath = directory.appendingPathComponent("rendered-Video.mp4")
        do { // delete old video
                try FileManager.default.removeItem(at: filePath)
            } catch { print(error.localizedDescription) }
        AVAssetExportSession.determineCompatibility(ofExportPreset: preset, with: asset, outputFileType: newFileType) { isCompatible in
            guard isCompatible else { print("Not compatible"); return }
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: preset) else { return }
            exportSession.outputFileType = newFileType
            exportSession.outputURL = filePath
            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .failed:
                    print("%@",exportSession.error! as Any)
                case .completed:
                    print("complete!")
                    // let formattedData = try! Data(contentsOf: fullURL)
                    print(exportSession.outputURL as Any)
                    let mediaPath = "file://\(exportSession.outputURL!.path as String)"
                    print(mediaPath)
                    completion(mediaPath, nil)
                default:
                    print("Default Case")
                }
            }
        }
    }
}

extension Data {
    func getAVAsset() -> AVAsset {
        let directory = NSTemporaryDirectory()
        let fileName = "\(NSUUID().uuidString).mov"
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        try! self.write(to: fullURL!)
        let asset = AVAsset(url: fullURL!)
        return asset
    }
    func m4aURL() -> URL? {
        let directory = NSTemporaryDirectory()
        let fileName = "\(NSUUID().uuidString).m4a"
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        try! self.write(to: fullURL!)
        return fullURL
    }
}
