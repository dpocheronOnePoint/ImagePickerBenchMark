//
//  PopupImagePickerView.swift
//  ImagePickersBenchmark
//
//  Created by Dimitri POCHERON on 27/06/2022.
//

import SwiftUI
import Photos

struct PopupImagePickerView: View {
    
    @StateObject var imagePickerViewModel = ImagePickerViewModel()
    @Environment(\.self) var env
    
    let deviceSize = UIScreen.main.bounds.size
    
    
    var onEnd: () -> ()
    var onSelect: ([PHAsset]) -> ()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Select Images")
                    .font(.callout.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    onEnd()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.primary)
                })
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(),spacing: 10),count: 4), spacing: 12) {
                        ForEach($imagePickerViewModel.fetchedImages) { $imageAsset in
                            GridContent(imageAsset: imageAsset)
                                .onAppear {
                                    if imageAsset.thumbnail == nil {
                                        let manager = PHCachingImageManager.default()
                                        manager.requestImage(for: imageAsset.asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) {
                                            image, _ in
                                            imageAsset.thumbnail = image
                                        }
                                    }
                                }
                        }
                    }
                    .padding()
            }
            .safeAreaInset(edge: .bottom) {
                Button{
                    let imageAssets = imagePickerViewModel.selectedImages.compactMap { imageAsset -> PHAsset? in
                        return imageAsset.asset
                    }
                    onSelect(imageAssets)
                } label: {
                    Text("Add \(imagePickerViewModel.selectedImages.isEmpty ? "" : "\(imagePickerViewModel.selectedImages.count) Images")")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(.blue)
                        }
                }
                .disabled(imagePickerViewModel.selectedImages.isEmpty)
                .opacity(imagePickerViewModel.selectedImages.isEmpty ? 0.6 : 1)
                .padding(.vertical)
            }
        }
        .frame(height: deviceSize.height / 1.8)
        .frame(maxWidth: (deviceSize.width - 40) > 350 ? 350 : (deviceSize.width - 40))
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(.white)
        }
        .frame(width: deviceSize.width, height: deviceSize.height, alignment: .center)
    }
    
    @ViewBuilder
    func GridContent(imageAsset: ImageAsset) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            ZStack {
                if let thumbnail = imageAsset.thumbnail {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                } else {
                    ProgressView()
                        .frame(width: size.width, height: size.height, alignment: .center)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.black.opacity(0.1))
                    
                    Circle()
                        .fill(.white.opacity(0.25))
                    
                    Circle()
                        .stroke(.white, lineWidth: 1)
                    
                    if let index = imagePickerViewModel.selectedImages.firstIndex(where: { asset in
                        asset.id == imageAsset.id
                    }) {
                        Circle()
                            .fill(.blue)
                        
                        Text("\(imagePickerViewModel.selectedImages[index].assetIndex + 1)")
                            .font(.caption2.bold())
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 20, height: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(5)
            }
            .clipped()
            .onTapGesture {
                withAnimation(.easeInOut) {
                    if let index = imagePickerViewModel.selectedImages.firstIndex(where: { asset in
                        asset.id == imageAsset.id
                    }) {
                        // MARK: - Remove and Update Selected Index
                        imagePickerViewModel.selectedImages.remove(at: index)
                        imagePickerViewModel.selectedImages.enumerated().forEach { item in
                            imagePickerViewModel.selectedImages[item.offset].assetIndex = item.offset
                        }
                    } else {
                        // MARK: - Add New
                        var newAsset = imageAsset
                        newAsset.assetIndex = imagePickerViewModel.selectedImages.count
                        imagePickerViewModel.selectedImages.append(newAsset)
                    }
                }
            }
        }
        .frame(height: 70)
    }
}
