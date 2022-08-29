//
//  ContentView.swift
//  IPFSTest
//
//  Created by Bryan Albert on 8/28/22.
//

import SwiftUI
import Photos
import IPFSKit


struct ContentView: View {
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var ipfsToggle = false
    @State private var isLoading = false
    @State private var imageIsPicked = false
    @State private var alertIsPresenting = false
    
    let projectId = "YOUR-PROJECT-ID"
    let secret = "YOUR-SECRET"
    
    var body: some View {
        VStack() {
            image?
                .resizable()
                .scaledToFit()
            HStack() {
                Button("Choose Image") {
                    showingImagePicker = true
                }
                .buttonStyle(MyButtonStyle())
                .onChange(of: inputImage) { _ in
                    loadImage()
                }
         
                Button {
                    ipfsToggle.toggle()
                    isLoading.toggle()
                } label: {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Add to IPFS")
                    }
                }
                .buttonStyle(MyButtonStyle())
                .disabled(isLoading)
                .onChange(of: ipfsToggle) { _ in
                    ipfsAdd(fileData: inputImage?.pngData()) { cid, error in
                        if let error = error {
                            print(error)
                            isLoading.toggle()
                        } else {
                            print("Success: ", cid!)
                            isLoading.toggle()
                        }
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                .alert(isPresented: $alertIsPresenting) {
                    Alert(title: Text("Unable to Add"), message: Text("Choose an image first"))
                }
            }
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
                    print("URI ", uri)
                    completion(uri, nil)
                }
            } catch let error {
                GraniteLogger.info("error adding new image:\n\(error)", .expedition, focus: true)
            }
        }
        else {
            alertIsPresenting.toggle()
            isLoading.toggle()
        }
    }
}
