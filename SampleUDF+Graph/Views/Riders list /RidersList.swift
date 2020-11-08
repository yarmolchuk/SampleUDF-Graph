//
//  RidersList.swift
//  SampleUDF+Graph
//
//  Created by Dima Yarmolchuk on 06.11.2020.
//

import SwiftUI
import Core

struct RidersList<RiderRow: View>: View {
    let ids: [Rider.Id]
    let loadNextPage: Command?
    
    let row: (Rider.Id) -> RiderRow
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ids, id:\.self) { id in
                    NavigationLink(
                        destination: self.details(id: id),
                        label: { self.row(id) }
                    )
                }
                
                if loadNextPage != nil {
                    Text("Loading...").onAppear(perform: loadNextPage)
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Riders")
        }
    }
    
    func details(id: Rider.Id) -> some View {
        RiderDetailsConnector(id: id)
    }
}

struct RidersList_Previews: PreviewProvider {
    static var previews: some View {
        RidersList(
            ids: Array(arrayLiteral: "1", "2", "3").map(Rider.Id.init),
            loadNextPage: nop,
            row: { id in RiderRow(
                fullName: "Valentino Rossi",
                team: "Yamaha Factory Racing",
                poster: nil
            )}
        )
    }
}

import Core

struct RidersListConnector: Connector {
    func map(graph: Graph) -> some View {
        let ridersList = {
            RidersList(
                ids: graph.ridersList.ids,
                loadNextPage:  nil,
                row: { RiderRowConnector(id: $0) }
            )
        }
        
        return ridersList()
    }
}


