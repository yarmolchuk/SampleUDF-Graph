//
//  RidersList.swift
//
//  Created by Dima Yarmolchuk on 06.11.2020.
//

import Foundation

public struct RidersList {
    public var ids: [Rider.Id] = []
    public var request: UUID? = UUID()
    
    mutating func reduce(_ action: Action) {
        switch action {            
        case let action as ReceiveRiders:
            request = nil
            ids += action.riders.map(\.id)
            
        default: break
        }
    }
}
