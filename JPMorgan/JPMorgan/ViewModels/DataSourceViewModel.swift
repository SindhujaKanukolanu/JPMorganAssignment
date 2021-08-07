//
//  DataSourceViewModel.swift
//  JPMorgan
//
//  Created by Sri Sai Sindhuja, Kanukolanu on 06/08/21.
//

import Foundation
import Combine
import UIKit

enum NetworkError: Error {
    case Success
    case Failure
}

class DataSourceViewModel {
    
    var cards = [SectionModel]()
    private var cancellable: AnyCancellable?
    var jsonObject = [String:AnyObject]()
    var allCancellable = Set<AnyCancellable>()
    var models = [SectionModel]()
    @Published var cardNames : AnyCancellable?


    
    init() {
        getResponseData()
    }
        
    func getResponseData() {
        if let urlString = URL(string: "https://swapi.dev/api/planets/") {
            let jsonPublisher =  URLSession.shared.dataTaskPublisher(for: urlString)
                .tryMap ({ (data, response) -> Data in
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 400 {
                            print("unauthorized")
                        }
                    }
                    return data
                }).decode(type: Model.self, decoder: JSONDecoder()).eraseToAnyPublisher()
                
           // consume the value to Upadte the model
            jsonPublisher.sink { (completion) in
                switch(completion) {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("sink finished sucessfullhy")
                }
            } receiveValue: {(users: Model) in
                self.updateSectionModel(models: users)
            }.store(in: &allCancellable)
        }
    }
    
    func updateSectionModel(models:Model) {
        for each in models.results {
            let cardModel = SectionModel(title:"", rows: [DataModel(planetName: each.name)])
            cards.append(cardModel)
        }
        saveDataInDefaults()
    }
    
    func fetchCards() -> AnyPublisher<[SectionModel], NetworkError> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let updatedCards = self?.cards else {
                    promise(.failure(.Failure))
                    return
                }
                promise(.success(updatedCards))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveDataInDefaults() {
        var planetsArray : [String] = []
        let userDefaults = UserDefaults.standard
        cards.forEach { model in
            model.rows.forEach { dataModel in
                planetsArray.append(dataModel.planetName)
            }
        }
        userDefaults.set(planetsArray, forKey: "OfflineArray")
        userDefaults.synchronize()
    }
}
