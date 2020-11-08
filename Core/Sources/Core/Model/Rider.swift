public struct Rider {
    public struct Id: Hashable {
        public init(value: String) {
            self.value = value
        }
        
        public let value: String
    }
    
    public init(
        id: Id,
        name: String,
        number:String,
        team: String,
        bike: String,
        placeOfBirth: String,
        dateOfBirth: String,
        weight: String,
        height: String,
        photoUrl: String,
        teamUid: String
    ) {
        self.id = id
        self.teamUid = teamUid
        
        self.name = name
        self.number = number
        self.team = team
        self.bike = bike
        self.placeOfBirth = placeOfBirth
        self.dateOfBirth = dateOfBirth
        self.weight = weight
        self.height = height
        self.photoUrl = photoUrl
    }
    
    public let id: Id
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
