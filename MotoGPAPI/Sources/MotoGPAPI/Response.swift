import Foundation

extension Client {
    public enum Response<Result: Decodable> {
        case success(Result)
        case cancelled
        case failed
    }
}
