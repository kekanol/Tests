//
//  SmallViews.swift
//  Test
//
//  Created by Константин on 26.04.2021.
//

import SwiftUI

struct LoadButton: View {
    var loader: Loader
    @Binding var searchedText: String
    var body: some View {
        Button(action: {
            if loader.isLastArrayIsSearched {
                loader.searchedOffset += 10
                loader.searchByName()
            } else {
                loader.citiesOffset += 10
                loader.loadArray()
            }
        }) {
            HStack {
                Spacer()
                Text("Load More")
                Spacer()
            }
            .padding()
            .background(Color(.lightGray))
            .cornerRadius(10)
        }.padding()
        .opacity(loader.model.cities.isEmpty ? 0 : 1)
    }
}

struct ScrollViewCell: View {
    @Binding var shown: Bool
    var loader: Loader
    var city: City
    var body: some View {
        Button(action: {
            loader.serchByID(id: city.id, completion: {
                shown.toggle()
            })
        }) {
            HStack {
                Text("\(city.city), \(city.country)")
                Spacer()
            }
            .fullScreenCover(isPresented: $shown) {
                SecondView(city: loader.model.choosed, shown: $shown)
            }
            
        }
        .padding()
        .background(Color(.lightGray))
        .cornerRadius(10)
        .buttonStyle(PlainButtonStyle())
    }
}

struct ShowIndicatorView: View {
    var loader: Loader
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                AnimationView(showProgress: loader.model.showIndicator)
                    .frame(width: 120, height: 100, alignment: .center)
                Spacer()
            }
            Spacer()
        }
    }
}

struct ErrorsView: View {
    var loader: Loader
    var body: some View {
        Text("Some Mistake! Check Connection and tap to reload")
            .foregroundColor(.red)
            .background(Color(.white))
            .font(.largeTitle)
            .onTapGesture {
                if loader.isLastArrayIsSearched {
                    loader.clearCities()
                    loader.searchByName()
                } else {
                    loader.clearCities()
                    loader.loadArray()
                }
            }
    }
}

