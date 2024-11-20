//
//  CameraView.swift
//  FiltersAppSwiftUI
//
//  Created by Mohammad Alabed on 17/11/2024.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var filter: FilterModel

    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraVC = CameraViewController()
        return cameraVC
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        uiViewController.applyFilter(named: filter.filterName, intensity: filter.intensity)
    }
}
