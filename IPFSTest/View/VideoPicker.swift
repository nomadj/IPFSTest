//
//  VideoPicker.swift
//  IPFSTest
//
//  Created by Bryan Albert on 9/20/22.
//

import SwiftUI
import PhotosUI

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var videoURL: String?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        // config.filter = .images
        config.filter = .videos
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: VideoPicker

        init(_ parent: VideoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else {return}
            provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                guard error == nil else{
                    print(error!)
//                    if provider.canLoadObject(ofClass: UIImage.self) {
//                        provider.loadObject(ofClass: UIImage.self) { image, _ in
////                            if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
////                            }
//                            self.parent.image = image as? UIImage
//                        }
//                    }
                    return
                }
                // receiving the video-local-URL / filepath
                guard let url = url else {return}
                // create a new filename
                let fileName = "\(Int(Date().timeIntervalSince1970)).\(url.pathExtension)"
                // create new URL
                let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
                // copy item to APP Storage
                try? FileManager.default.copyItem(at: url, to: newUrl)
                self.parent.videoURL = newUrl.absoluteString
                }
        }
    }
}
