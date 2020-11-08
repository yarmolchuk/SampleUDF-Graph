import NetworkOperator
import Dispatch
import Core
import MotoGPAPI
import Foundation

struct NetworkDriver {
    let store: Store
    let client: Client
    let `operator`: NetworkOperator
    
    var asObserver: Observer {
        Observer(queue: self.operator.queue) { state in
            self.observe(state: state)
            return .active
        }
    }
    
    func observe(state: AppState) {
        var requests = [NetworkOperator.Request]()
        
        defer {
            self.operator.process(props: requests)
        }
        
        func fire<Data: Decodable>(
            _ id: UUID,
            request: Client.Request<Data>,
            onComplete: @escaping (Client.Response<Data>) -> Action
        ) {
            requests.append(NetworkOperator.Request(
                id: id,
                request: request.urlRequest,
                handler: { data, response, error in
                    let result = request.handler(data, response, error)
                    let action = onComplete(result)
                    self.store.dispatch(action: action)
            }))
        }
        
        if let id = state.allRiders.request {
            fire(id, request: client.getAllRiders()) { response in
                guard case let .success(result) = response else {
                    preconditionFailure("Some error")
                }
                
                return ReceiveRiders(riders: result.asRiders)
            }
        }
    }
}

extension Client.RiderListResult.Result {
    var asCoreRider: Core.Rider {
        Rider(
            id: Rider.Id(value: uid),
            name: name,
            number: number,
            team: team,
            bike: bike,
            placeOfBirth: placeOfBirth,
            dateOfBirth: dateOfBirth,
            weight: weight,
            height: height,
            photoUrl: photoUrl,
            teamUid: teamUid
        )
    }
}

extension Client.RiderListResult {
    var asRiders: [Rider] {
        items.map(\.asCoreRider)
    }
}
