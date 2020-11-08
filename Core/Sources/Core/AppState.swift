import Foundation

public struct AppState {
    public var allRiders = AllRiders()
    public var ridersList = RidersList()
    
    public mutating func reduce(_ action: Action) {
        allRiders.reduce(action)
        ridersList.reduce(action)
    }
    
    public init() {}
}
