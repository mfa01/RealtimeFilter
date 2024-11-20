//
//  ContentView.swift
//  FiltersAppSwiftUI
//
//  Created by Mohammad Alabed on 17/11/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedFilter: FilterModel
    
    init() {
        selectedFilter = FiltersManager.defaultFilter
    }
    
    var body: some View {
        VStack {
            CameraView(filter: $selectedFilter)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    VStack {
                        Spacer()
                        // Slider for adjusting filter intensity
                        intensityView
                        Picker("Filter", selection: $selectedFilter) {
                            ForEach(FiltersManager.mockedFilters, id: \.self) { filter in
                                Text(filter.displayName)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        .background(Color.brown.opacity(0.6))
                    }
                )
        }
    }
    
    var intensityView: some View {
        if let intensity = selectedFilter.intensity {
            return VStack {
                Text("Intensity: \(String(format: "%.2f", intensity))")
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                
                Slider(
                    value: Binding(
                        get: { intensity },
                        set: { newValue in
                            selectedFilter.intensity = newValue
                        }
                    ),
                    in: 0.0...1.0
                )
                .accentColor(.yellow)
                .padding()
            }
            .background(Color.black.opacity(0.6))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
}
