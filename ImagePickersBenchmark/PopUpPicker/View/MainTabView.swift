//
//  MainTabView.swift
//  ImagePickersBenchmark
//
//  Created by Dimitri POCHERON on 27/06/2022.
//

import SwiftUI
import PhotosUI

struct MainTabView: View {
    
    @State var showPicker: Bool = false
    @State var pickerImages: [UIImage] = []
    
    var body: some View {
        NavigationView {
            TabView {
                ForEach(pickerImages, id: \.self) { image in
                    GeometryReader { proxy in
                        let size = proxy.size
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .cornerRadius(15)
                    }
                    .padding()
                }
            }
            .frame(height: 450)
            // MARK: - SwiftUI Crash
            // If you don't have any view inside tabView
            // it's crashing but not in never
            
            .tabViewStyle(.page(indexDisplayMode: pickerImages.isEmpty ? .never : .always))
            .navigationTitle("Popup Image Picker")
            .toolbar {
                Button(action: {
                    showPicker.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
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

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
