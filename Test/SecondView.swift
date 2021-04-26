//
//  SecondView.swift
//  Test
//
//  Created by Константин on 22.04.2021.
//

import SwiftUI

struct SecondView: View {
    
    var city: City
    @Binding var shown: Bool
    var body: some View {
        HStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {shown.toggle()}, label: {
                        Image(systemName: "xmark.circle.fill")
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    Spacer()
                }
                HStack {
                    Text("City Name: ")
                    Text(city.city)
                }
                HStack {
                    Text("Country: ")
                    Text(city.country)
                }
                HStack {
                    Text("CountryCode: ")
                    Text(city.countryCode)
                }
                HStack {
                    Text("Elevation Meters: ")
                    Text("\(city.elevationMeters ?? 0)")
                }
                HStack {
                    Text("Population: ")
                    Text("\(city.population)")
                }
                Spacer()
                Button(action: {
                    guard let url = URL(string: "https://www.wikidata.org/wiki/\(city.wikiDataId)") else { return }
                    UIApplication.shared.open(url)
                }) {
                    Image("wiki")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                }
                .padding(.bottom)
            }.font(.title)
        }
    }
}


