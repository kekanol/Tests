//
//  ContentView.swift
//  Test
//
//  Created by Константин on 22.04.2021.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject private var loader = Loader()
    @State private var shown = false
    var body: some View {
        VStack {
            
            // Search view
            HStack {
                TextField("Search", text: $loader.text)
                    .foregroundColor(.primary)
                    .onReceive(loader.$text.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) { _ in
                        loader.clearCities()
                        if loader.text == "" {
                            loader.citiesOffset = 0
                            loader.searchedOffset = 0
                            loader.loadArray()
                        } else {
                            loader.searchByName()
                        }
                    }
                    .keyboardType(.alphabet)
                
                
                Button(action: {
                    loader.text = ""
                    loader.citiesOffset = 0
                    loader.searchedOffset = 0
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(loader.text == "" ? 0 : 1)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            
            
            ZStack(alignment: .center) {
                ScrollView(.vertical) {
                    ForEach(loader.model.cities, id: \.self) { city in
                        ScrollViewCell(shown: $shown, loader: loader, city: city)
                    }
                    .padding()
                    
                    LoadButton(loader: loader, searchedText: $loader.text)
                }
                .resignKeyboardOnDragGesture()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                
                if loader.model.showIndicator {
                    ShowIndicatorView(loader: loader)
                }
                
                if loader.model.errors {
                    ErrorsView(loader: loader)
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
            .navigationBarHidden(true)
            .foregroundColor(loader.model.showIndicator ? .gray : .primary)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

