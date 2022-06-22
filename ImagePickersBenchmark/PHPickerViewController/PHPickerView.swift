//
//  PHPickerView.swift
//  ImagePickersBenchmark
//
//  Created by Dimitri POCHERON on 22/06/2022.
//

import SwiftUI

struct PHPickerView: View {
    @ObservedObject private var phpickerViewModel = PHPickerViewModel()
    
    @State private var showingImagePicker = false
    var body: some View {
        VStack {
            if((phpickerViewModel.profileImage) != nil) {
                phpickerViewModel.profileImage?
                    .resizable()
                    .frame(width: 200, height: 200)
            } else {
                Image(systemName: "person.fill.viewfinder")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentColor)
                    .padding(30)
                    .background(Color.primary)
                    .cornerRadius(100)
                    .onTapGesture {
                        showingImagePicker = true
                    }
            }
        }
        .onChange(of: phpickerViewModel.profileInputImage) { _ in
            phpickerViewModel.loadProfileImage()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $phpickerViewModel.profileInputImage)
        }
    }
}

struct PHPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PHPickerView()
    }
}
