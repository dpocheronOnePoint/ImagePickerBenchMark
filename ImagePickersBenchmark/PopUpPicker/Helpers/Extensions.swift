//
//  Extensions.swift
//  ImagePickersBenchmark
//
//  Created by Dimitri POCHERON on 28/06/2022.
//

import SwiftUI
import PhotosUI

extension View {
    @ViewBuilder
    func popupImagePicker(show: Binding<Bool>, transition: AnyTransition = .move(edge: .bottom), onSelect: @escaping ([PHAsset]) -> ()) -> some View {
        self
            .overlay {
                
                let deviceSize = UIScreen.main.bounds.size
                
                ZStack {
                    
                    // MARK: - Blur Background
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .opacity(show.wrappedValue ? 1 : 0)
                        .onTapGesture {
                            show.wrappedValue = false
                        }
                    
                    if show.wrappedValue {
                        PopupImagePickerView {
                            show.wrappedValue = false
                        } onSelect: { assets in
                            onSelect(assets)
                            show.wrappedValue = false
                        }
                        .transition(transition)
                    }
                }
                .frame(width: deviceSize.width, height: deviceSize.height)
                .animation(.easeInOut, value: show.wrappedValue)
            }
    }
}
