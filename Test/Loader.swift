//
//  Loader.swift
//  Test
//
//  Created by Константин on 22.04.2021.
//

import SwiftyJSON
import SwiftUI

final class Loader: ObservableObject {
    
    @Published var model = Model()
    @Published var text: String = ""

    var isLastArrayIsSearched: Bool = false
    var citiesOffset: Int = 0
    var searchedOffset: Int = 0
    
    private var array: [City] = []
    private var errors: Bool = false
    private var showIndicator = false
    private var choosed =  City()
    
    func loadArray() -> Void {
        let headers = [
            "x-rapidapi-key": "e77c5a4a08msh9f4ddc7bbf0c983p1eb248jsnada72eeac421",
            "x-rapidapi-host": "wft-geo-db.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(
            url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?offset=\(citiesOffset)&limit=10")! as URL,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 5.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            guard let dataResponse = data,
                  error == nil else {
                self.errors = true
                update()
                print(error?.localizedDescription ?? "Response Error")
                return }
            do {
                let json = try JSON(data: dataResponse)
                guard let data = json["data"].array else { return }
                for element in data {
                    var city = City()
                    city.city = element["city"].string ?? ""
                    city.country = element["country"].string ?? ""
                    city.id = element["id"].int ?? 0
                    if !self.array.contains(city) {
                        self.array.append(city)
                    }
                }
                self.errors = false
            } catch let parsingError {
                print("Error", parsingError)
            }
            self.showIndicator = false
            update()
        })
        dataTask.resume()
        self.isLastArrayIsSearched = false
        self.showIndicator = true
        update()
    }
    
    
    func searchByName() -> Void {
        let headers = [
            "x-rapidapi-key": "e77c5a4a08msh9f4ddc7bbf0c983p1eb248jsnada72eeac421",
            "x-rapidapi-host": "wft-geo-db.p.rapidapi.com"
        ]
        let newname = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let request = NSMutableURLRequest(
            url: URL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?offset=\(searchedOffset)&limit=10&namePrefix=\(newname)")!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 5.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            
            guard let dataResponse = data,
                  error == nil else {
                self.errors = true
                update()
                print(error?.localizedDescription ?? "Response Error")
                return }
            do {
                let json = try JSON(data: dataResponse)
                
                guard let data = json["data"].array else { return }
                for element in data {
                    var city = City()
                    city.city = element["city"].string ?? ""
                    city.country = element["country"].string ?? ""
                    city.id = element["id"].int ?? 0
                    self.array.append(city)
                }
                self.errors = false
                self.showIndicator = false
            } catch let parsingError {
                print("Error", parsingError)
            }
            update()
        })
        dataTask.resume()
        self.isLastArrayIsSearched = true
        self.showIndicator = true
        update()
    }
    
    func serchByID(id: Int, completion: @escaping (() -> Void)) -> Void {
        let headers = [
            "x-rapidapi-key": "e77c5a4a08msh9f4ddc7bbf0c983p1eb248jsnada72eeac421",
            "x-rapidapi-host": "wft-geo-db.p.rapidapi.com"
        ]
        let request = NSMutableURLRequest(
            url: URL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities/\(id)")!,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            guard let dataResponse = data,
                  error == nil else {
                self.errors = true
                update()
                print(error?.localizedDescription ?? "Response Error")
                return }
            do {
                let json = try JSON(data: dataResponse)
                let data = json["data"].dictionaryValue
                self.choosed.countryCode = data["countryCode"]?.string ?? ""
                self.choosed.population = data["population"]?.int ?? 0
                self.choosed.elevationMeters = data["elevationMeters"]?.int
                self.choosed.wikiDataId = data["wikiDataId"]?.string ?? ""
                self.choosed.city = data["city"]?.string ?? ""
                self.choosed.country = data["country"]?.string ?? ""
                self.choosed.id = data["id"]?.int ?? 0
                self.errors = false
            } catch let parsingError {
                print("Error", parsingError)
            }
            self.showIndicator = false
            update()
            completion()
        })
        dataTask.resume()
        self.showIndicator = true
        update()

    }
    
    func clearCities() {
        self.array.removeAll()
        model.cities.removeAll()
    }
    
    private func update() {
        DispatchQueue.main.async {
            self.model.showIndicator = self.showIndicator
            self.model.choosed = self.choosed
            self.model.cities = self.array
            self.model.errors = self.errors
            self.objectWillChange.send()
        }
    }
}


