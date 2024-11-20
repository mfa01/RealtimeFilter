//
//  FiltersManager.swift
//  FiltersAppSwiftUI
//
//  Created by Mohammad Alabed on 17/11/2024.
//

import Foundation

class FiltersManager {
    static let mockedFilters: [FilterModel] = [
        .init(displayName: "Sepia", filterName: "CISepiaTone", intensity: 0.0),
        .init(displayName: "Mono", filterName: "CIPhotoEffectMono", intensity: nil),
        .init(displayName: "Noir", filterName: "CIPhotoEffectNoir", intensity: nil),
        .init(displayName: "Chrome", filterName: "CIPhotoEffectChrome", intensity: nil),
        .init(displayName: "Instant", filterName: "CIPhotoEffectInstant", intensity: nil),
        .init(displayName: "Fade", filterName: "CIPhotoEffectFade", intensity: nil)
    ]
    
    static var defaultFilter: FilterModel {
        Self.mockedFilters[0]
    }
}
