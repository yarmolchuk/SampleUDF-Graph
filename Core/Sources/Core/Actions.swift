import Foundation

public protocol Action {}

public struct ReceiveRiders: Action {
    public init(riders: [Rider]) {
        self.riders = riders
    }
    
    public let riders: [Rider]
}

public struct DidLoadPoster: Action {
    public init(rider: Rider.Id) {
        self.rider = rider
    }
    
    public let rider: Rider.Id
}
