//
//  ImagePicker.swift
//  ImagePickersBenchmark
//
//  Created by Dimitri POCHERON on 22/06/2022.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let selectionLimit: Int
    @Binding var bindingAssetIdentifierArray: [String]
    var assetIdentifierArray: [String]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let photoLibrary = PHPhotoLibrary.shared()
        var config = PHPickerConfiguration(photoLibrary: photoLibrary)
        config.filter = .images
        config.selectionLimit = selectionLimit
        config.preselectedAssetIdentifiers = assetIdentifierArray
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
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            
//            guard let provider = results.first?.itemProvider else { return }
            for i in 0...results.count - 1 {
                let provider = results[i].itemProvider
                let assetIdentifier = results[i].assetIdentifier ?? ""
                print("asset --> \(assetIdentifier)")
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, _ in
                        DispatchQueue.main.async {
                            self.parent.bindingAssetIdentifierArray.append(assetIdentifier)
                            self.parent.image = image as? UIImage
                        }
                    }
                }
            }
        }
    }
}
