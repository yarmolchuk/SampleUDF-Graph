import Foundation

func update<T>(_ value: T, code: (inout T) -> ()) -> T {
    var value = value
    code(&value)
    return value
}


public struct Client {
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public let baseURL: URL
    
    let encoder = update(JSONEncoder()) { encoder in
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    let decoder = update(JSONDecoder()) { decoder in
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func defaultHandler<Result: Decodable>(data: Data?, response: URLResponse?, error: Error?) -> Response<Result> {
        if let error = error as NSError? {
            switch (error.domain, error.code) {
            case (NSURLErrorDomain, NSURLErrorCancelled): return .cancelled
            default: return .failed
            }
        }
        
        guard let response = response as? HTTPURLResponse else {
            preconditionFailure("Response must be here if error is nil")
        }
        
        if response.statusCode != 200 {
            return .failed
        }
        
        guard let data = data else {
            preconditionFailure("Data need to be here")
        }
        
        do {
            let result = try decoder.decode(Result.self, from: data)
            return .success(result)
        } catch {
            print(error)
            return .failed
        }
    }
    
    func urlRequest(for path: String, with params: [URLQueryItem] = []) -> URLRequest {
        var url = baseURL
        url.appendPathComponent(path)
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        return URLRequest(url: components.url!)
    }
    
    func get(from path: String, with params: [URLQueryItem] = []) -> URLRequest {
        urlRequest(for: path, with: params)
    }
    
    func request<Result: Decodable>(urlRequest: URLRequest) -> Request<Result> {
        Request(urlRequest: urlRequest, handler: defaultHandler)
    }
    
    public struct RiderListResult: Decodable {
        public let items: [Result]
        
        public struct Result: Decodable {
            public let uid: String
            public let teamUid: String
            public let name: String
            public let team: String
            public let number: String
            public let bike: String
            public let placeOfBirth: String
            public let dateOfBirth: String
            public let weight: String
            public let height: String
            public let photoUrl: String
        }
    }
    
    public func getAllRiders() -> Request<RiderListResult> {
        return request(urlRequest: get(from: "motogpriders/riders.json"))
    }
}
