import SwiftUI
import SwiftData

struct RewindView: View {
    @Environment(\.modelContext) private var modelContext
    
    let mode: Mode
    let startDate: Date?
    let endDate: Date?
    let location: String?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 40) {
                ForEach(filterMemory(mode: mode, startDate: startDate, endDate: endDate, location: location, context: modelContext)) { memory in
                    DetailView(uuid: memory.uuid)
                        .scrollTransition(axis: .horizontal) { content, phase in
                            return content
//                                .scaleEffect(1 - abs(phase.value)*0.1)
                                .offset(x: phase.value * -250)
                                .blur(radius: abs(phase.value) * 5)
                        }
                        .clipShape(Rectangle())
                }
            }
            .scrollTargetLayout()
        }
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned)
        .ignoresSafeArea(edges: .all)
    }
}

enum Mode {
    case time
    case location
    case getStart
}

func filterMemory(mode: Mode, startDate: Date?, endDate: Date?, location: String? , context: ModelContext) -> [Memory] {
    var predicate: Predicate<Memory>?
    switch mode {
    case .time:
        predicate = #Predicate<Memory> { memory in 
            memory.date > startDate! && memory.date < endDate!
        }
        break
    case .location:
        predicate = #Predicate<Memory> { memory in
            memory.location == location!
        }
        break
    default:
        predicate = nil
        break
    }
    let descriptor = FetchDescriptor(predicate: predicate)
    
    return try! context.fetch(descriptor)
}

#Preview {
    RewindView(mode: Mode.time, startDate: nil, endDate: nil, location: nil)
}
