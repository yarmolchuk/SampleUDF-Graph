//
//  RiderNode.swift
//
//  Created by Dima Yarmolchuk on 06.11.2020.
//

import Foundation

extension Graph {
    public func rider(id: Rider.Id) -> RiderNode {
        return RiderNode(graph: self, id: id)
    }
}

public struct RiderNode {
    let graph: Graph
    let id: Rider.Id
    
    var entity: Rider { graph.state.allRiders.byId[id]! }
    
    public var name: String { entity.name }
    public var team: String { entity.team }
}
