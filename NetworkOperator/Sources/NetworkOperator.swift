import Foundation

public class NetworkOperator {
    private let session: URLSession
    public let queue: DispatchQueue
    public var enableTracing = false
    
    public init(configuration: URLSessionConfiguration = .default,
                queue: DispatchQueue = DispatchQueue(label: "Network operator")) {
        
        session = URLSession(configuration: configuration)
        self.queue = queue
    }
    
    public typealias Props = [Request]
    
    public func process(props: Props) {
        var remainedActiveRequestsIds = Set(activeRequests.keys)
        
        for request in props {
            process(request: request)
            remainedActiveRequestsIds.remove(request.id)
        }
        
        for cancelledRequestId in remainedActiveRequestsIds {
            cancel(requestId: cancelledRequestId)
        }
    }
    
    private var activeRequests: [UUID: (request: Request, task: URLSessionDataTask)] = [:]
    private var completedRequests: Set<UUID> = []
    
    private func process(request: Request) {
        if completedRequests.contains(request.id) {
            return
        }
        
        if activeRequests.keys.contains(request.id) {
            activeRequests[request.id]!.request = request // Update request to its latest version
        } else {
            // Create new task
            if (enableTracing) {
                print("Network:\t\t start \(request.request)")
                if let data = request.request.httpBody {
                    print("Network:\t\t body - \(String(data: data, encoding: .utf8)!)")
                }
            }
            
            let task = session.dataTask(with: request.request) { data, response, error in
                self.queue.asyncAfter(deadline: .now()) {
                    self.complete(request: request, data: data, response: response, error: error)
                }
            }
            
            activeRequests[request.id] = (request, task) // Store it to list of active tasks
            task.resume() // Begin task execution
        }
    }
    
    private func complete(request: Request, data: Data?, response: URLResponse?, error: Error?) {
        guard let currentRequest = activeRequests[request.id] else {
            preconditionFailure("Request not found")
        }
        
        activeRequests[request.id] = nil
        completedRequests.insert(request.id)
        
        currentRequest.request.handler(data, response, error)
    }
    
    func cancel(requestId: UUID) {
        guard let (_, task) = activeRequests[requestId] else {
            preconditionFailure("Request not found")
        }
        task.cancel() // Stop task execution
    }
}
