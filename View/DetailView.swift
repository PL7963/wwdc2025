import Foundation
import SwiftUIFlowLayout
import SwiftUI
import SwiftData

struct DetailView: View {
    let uuid: UUID
    
    @Environment(\.modelContext) private var modelContext
//    @Query private var memories: [Memory]
    
//    init(uuid: UUID) {
//        self.uuid = uuid
//        _memories = Query(filter: #Predicate<Memory> {$0.uuid == uuid})
//    }

//    var memory: Memory { memories.first! }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
//            Image(uiImage: UIImage(data: memory.photo)!).resizable().scaledToFill().ignoresSafeArea(.all).containerRelativeFrame(.vertical).clipped()
            if let memories = fetchMemory(uuid: uuid, context: modelContext),
                let memory = memories.first {
                Color.clear
                    .overlay { 
                        Image(uiImage: UIImage(data: memory.photo)!).resizable().scaledToFill()
                    }
                InformationCardView(date: memory.date, hashtags: memory.hashtags, location: memory.location)
                    .padding(16)
            }
        }
        .containerRelativeFrame(.horizontal)
        .clipped()
        .ignoresSafeArea()
    }
}

struct InformationCardView: View {
    let date: Date
    let hashtags: Array<String>
    let location: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(convertDate(date: date)).font(.title).foregroundStyle(.primary)
            Text("At " + location).font(.title2).foregroundStyle(.secondary)
            FlowLayout(mode: .scrollable, items: hashtags, itemSpacing: 4) {
                Text($0)
                    .padding([.leading, .trailing], 8)
                    .padding([.bottom, .top], 4)
                    .background(.thickMaterial)
                    .cornerRadius(4)
            }
        }
        .padding(16)
        .frame(width: 350)
        .background(.regularMaterial)
        .clipShape(Rectangle())
        .cornerRadius(16)
    }
}

private func fetchMemory(uuid: UUID, context: ModelContext) -> [Memory]? {
    var predicate = #Predicate<Memory> { memory in 
            memory.uuid == uuid
        }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    return try! context.fetch(descriptor)
}

private func convertDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = "MMMM d"
    let result = dateFormatter.string(from: date)
    
    return result
}

