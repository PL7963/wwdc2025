import Foundation
import SwiftData

@Model
class Memory {
    var date: Date
    var hashtags: Array<String>
    var location: String
    @Attribute(.externalStorage) var photo: Data
    @Attribute(.unique)var uuid: UUID
    
    init(date: Date, hashtags: Array<String>, location: String, photo: Data) {
        self.date = date
        self.hashtags = hashtags
        self.location = location
        self.photo = photo
        self.uuid = UUID()
    }
}
