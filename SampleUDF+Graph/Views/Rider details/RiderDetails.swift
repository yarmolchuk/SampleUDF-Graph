//
//  RiderDetails.swift
//  SampleUDF+Graph
//
//  Created by Dima Yarmolchuk on 08.11.2020.
//

import SwiftUI
import Core

struct RiderDetails: View {
    let poster: UIImage?
    let number: String
    let fullName: String
    let dateOfBirth: String
    let team: String
    let bike: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Group {
                    if (poster != nil) {
                        Image(uiImage: poster!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Color.gray
                    }
                }
                .frame(width: 115, height: 140)
                
                VStack(alignment: .leading) {
                    Text(fullName)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(dateOfBirth)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(number)
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
            }
            VStack(alignment: .leading) {
                Text("Team:")
                    .font(.headline)
                    .truncationMode(.tail)
                Text(team).truncationMode(.tail)
                Text("Bike:")
                    .font(.headline)
                    .truncationMode(.tail)
                Text(bike).truncationMode(.tail)
            }
        }
    }
}

import Core

struct RiderDetailsConnector: Connector {
    @Environment(\.imageCache) var imageCache
    let id: Rider.Id
            
    func map(graph: Graph) -> some View {
        let rider = graph.detailedRiderInfo(id: id)
        
        return RiderDetails(
            poster: imageCache.image(for: id),
            number: rider.number,
            fullName: rider.name,
            dateOfBirth: rider.dateOfBirth,
            team: rider.team,
            bike: rider.bike
        )
    }
}
