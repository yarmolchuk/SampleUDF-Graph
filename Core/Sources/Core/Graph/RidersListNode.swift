//
//  RidersListNode.swift
//
//  Created by Dima Yarmolchuk on 06.11.2020.
//

import Foundation

extension Graph {
    public var ridersList: RidersListNode {
        RidersListNode(graph: self)
    }
}

public struct RidersListNode {
    let graph: Graph
    
    var entity: RidersList { graph.state.ridersList }
    
    public var riders: [RiderNode] {
        entity.ids.map(graph.rider(id:))
    }
    public var ids: [Rider.Id] { entity.ids }
}
