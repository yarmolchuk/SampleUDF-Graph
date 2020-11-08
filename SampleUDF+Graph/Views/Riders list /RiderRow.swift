//
//  RiderRow.swift
//  SampleUDF+Graph
//
//  Created by Dima Yarmolchuk on 06.11.2020.
//

import SwiftUI

struct RiderRow: View {
    let fullName: String
    let team: String
    let poster: UIImage?
    
    var body: some View {
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
            .frame(width: 105, height: 135)
            
            VStack(alignment: .leading) {
                Text(fullName)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Text(team)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }
}

struct RiderRowConnector: Connector {
    @Environment(\.imageCache) var imageCache
    let id: Rider.Id
    
    func map(graph: Graph) -> some View {
        let rider = graph.rider(id: id)
        
        return RiderRow(
            fullName: rider.name,
            team: rider.team,
            poster: imageCache.image(for: id)
        )
    }
}
