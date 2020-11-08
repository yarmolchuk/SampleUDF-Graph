//
//  App.swift
//  SampleUDF+Graph
//
//  Created by Dima Yarmolchuk on 01.11.2020.
//

import SwiftUI
import NetworkOperator
import MotoGPAPI
import Core
import Combine

@main
struct MyMovies: App {
    @Environment(\.imageCache) var imageCache
    
    let store = Store(initial: AppState()) { state, action in
        print("Reduce\t\t\t", action)
        state.reduce(action)
    }
    let client = Client(
        baseURL: URL(string: "https://s3.eu-west-2.amazonaws.com/")!
    )
    
    let networkOperator = NetworkOperator()
    
    init() {
        networkOperator.enableTracing = true
        
        let networkDriver = NetworkDriver(store: store, client: client, operator: networkOperator)
        let imageLoader = ImageLoader(store: store, cache: imageCache)
        
        store.subscribe(observer: networkDriver.asObserver)
        store.subscribe(observer: imageLoader.asObserver)        
    }
    
    var body: some Scene {
        WindowGroup {
            StoreProvider(store: store) {
                RidersListConnector()
            }
        }
    }
}
