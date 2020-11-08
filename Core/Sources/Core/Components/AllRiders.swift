import Foundation

public struct AllRiders {
    public var byId: [Rider.Id: Rider] = [:]
    public var request: UUID? = UUID()
    
    mutating func reduce(_ action: Action) {
        switch action {
        case let action as ReceiveRiders:
            action.riders.forEach({ rider in
                byId[rider.id] = rider
            })
            
        default: break
        }
    }
}
