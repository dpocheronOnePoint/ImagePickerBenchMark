//
//  LazyGridSelectView.swift
//  ImagePickersBenchmark
//
//  Created by Dimitri POCHERON on 28/06/2022.
//

import SwiftUI
import PhotosUI

fileprivate let sizeValue: Double = 80.0

struct LazyGridSelectView: View {
    @State var showPicker: Bool = false
    @State var pickerImages: [UIImage] = []
    
    private let adaptiveColumns = [ GridItem(.adaptive(minimum: sizeValue))]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                    Button(action: {
                        showPicker.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                    
                    ForEach(pickerImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: sizeValue, height: sizeValue)
                            .cornerRadius(15)
                    }
                }
            }
        }
        .popupImagePicker(show: $showPicker) { assets in
            // MARK: - Do your operation with assets
            
            let manager = PHCachingImageManager.default()
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            DispatchQueue.global(qos: .userInteractive).async {
                assets.forEach { asset in
                    manager.requestImage(
                        for: asset,
                        targetSize: .init(),
                        contentMode: .default,
                        options: options) { image, _ in
                            guard let image = image else { return }
                            DispatchQueue.main.async {
                                self.pickerImages.append(image)
                            }
                        }
                }
            }
        }
    }
}

struct LazyGridSelectView_Previews: PreviewProvider {
    static var previews: some View {
        LazyGridSelectView()
    }
}
