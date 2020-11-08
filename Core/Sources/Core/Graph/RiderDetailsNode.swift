//
//  RiderDetailsNode.swift
//
//  Created by Dima Yarmolchuk on 08.11.2020.
//

import Foundation

extension Graph {
    public func detailedRiderInfo(id: Rider.Id) -> RiderDetailsNode {
        return RiderDetailsNode(graph: self, id: id)
    }
}

public struct RiderDetailsNode {
    let graph: Graph
    let id: Rider.Id
    
    var entity: Rider { graph.state.allRiders.byId[id]! }
    
    public var name: String { entity.name }
    public var number: String { entity.number }
    public var dateOfBirth: String { entity.dateOfBirth }
    public var team: String { entity.team }
    public var bike: String { entity.bike }
}
