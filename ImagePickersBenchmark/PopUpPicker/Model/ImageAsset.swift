//
//  ImageAsset.swift
//  ImagePickersBenchmark
//
//  Created by Dimitri POCHERON on 27/06/2022.
//

import PhotosUI

struct ImageAsset: Identifiable {
    var id = UUID()
    var asset: PHAsset
    var thumbnail: UIImage?
    var assetIndex: Int = -1
}
