//
//  PHPickerViewModel.swift
//  ImagePickersBenchmark
//
//  Created by Dimitri POCHERON on 22/06/2022.
//

import SwiftUI

class PHPickerViewModel: ObservableObject {
    @Published var profileImage: Image?
    @Published var profileInputImage: UIImage?
    @Published var assetIdentifierArray: [String] = []
    
    func loadProfileImage() {
        guard let profileInputImage = profileInputImage else { return }
        profileImage = Image(uiImage: profileInputImage)
    }
    
    func saveProfileImage() {
    }
}
