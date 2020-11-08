import NetworkOperator
import Foundation
import Dispatch
import UIKit
import Core

class ImageLoader {
    internal init(store: Store, cache: ImageCache) {
        self.store = store
        self.cache = cache
        
        self.network.enableTracing = true
    }
    
    let network = NetworkOperator()
    let store: Store
    let cache: ImageCache
    
    var asObserver: Observer {
        Observer(queue: network.queue, observe: { state in
            self.observe(state: state)
            return .active
        })
    }
    
    private var ids: [Rider.Id: UUID] = [:]
    
    func url(for poster: String) -> URL {
        URL(string: poster)!
    }
    
    func observe(state: AppState) {
        let riders = state.allRiders.byId.keys
        
        // Generate uuids for request mapping
        for rider in riders where !ids.keys.contains(rider) {
            ids[rider] = UUID()
        }
        
        let requests: [NetworkOperator.Request] = riders.compactMap { riderId in
            let uuid = ids[riderId]!
            
            let urlRequest = URLRequest(
                url: url(for: state.allRiders.byId[riderId]!.photoUrl)
            )

            let operatorRequest = NetworkOperator.Request(
                id: uuid,
                request: urlRequest,
                handler: handler(riderId: riderId)
            )
            
            return operatorRequest
        }
        
        network.process(props: requests)
    }
    
    func handler(riderId: Rider.Id) -> (Data?, URLResponse?, Error?) -> () {
        return { data, response, error in
            guard let data = data else {
                preconditionFailure("No data in reponse")
            }

            guard let image = UIImage(data: data) else {
                preconditionFailure("Cannot read image")
            }
            
            DispatchQueue.main.sync {
                self.cache.store(poster: image, for: riderId)
            }
        
            self.store.dispatch(action: DidLoadPoster(rider: riderId))
        }
    }
}
