import SwiftUI
import Combine
import Core

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = ImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

class ImageCache {
    private var posters = [Rider.Id: UIImage]()
    
    func store(poster image: UIImage, for id: Rider.Id) {
        posters[id] = image
    }
    
    func hasPoster(for id: Rider.Id) -> Bool {
        return posters.keys.contains(id)
    }
    
    func image(for id: Rider.Id) -> UIImage? {
        posters[id]
    }
}
