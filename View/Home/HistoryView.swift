import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \Memory.date, order: .reverse) private var memories: [Memory]
    @Environment(\.modelContext) private var modelContext
    @Namespace private var namespace
    
    var groupedMemories: [String: [Memory]] {
        Dictionary(grouping: memories) { memory in
            return convertDate(date: memory.date)
        }
    }
        
    let column = [
        GridItem(.adaptive(minimum: 370), spacing: 8)
    ]
    
    var body: some View {
        if(memories.count == 0) {
            VStack {
                Spacer()
                Image(systemName: "photo")
                    .resizable().scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundStyle(.primary)
                Text("No Saved Memories")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .font(.title)
                    .padding(.bottom, 8)
                Text("Save Memory by tapping add button on top right corner")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .font(.title3)
                Spacer()
            }
            .frame(height: 500)
        } else {
            ScrollView {
                ForEach(groupedMemories.keys.sorted(by: >), id: \.self) { key in
                    if let memories = groupedMemories[key],
                       let firstMemDate = memories.first {
                        HStack() {
                            Text(convertDate(date: firstMemDate.date, scheme: "MMMM YYYY"))
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .padding()
                            HStack() {
                                Image(systemName: "photo.stack")
                                Text("\(memories.count)")
                            }
                            .foregroundStyle(.secondary)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: column, spacing: 32){
                            ForEach(memories) { memory in
                                NavigationLink(value: memory.uuid) {
                                    memoryCard(image: memory.photo, location: memory.location)
                                        .matchedTransitionSource(id: memory.uuid, in: namespace)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                modelContext.delete(memory)
                                                try! modelContext.save()
                                            } label: {
                                                Label("Delete", image: "trash")
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: UUID.self) { uuid in
                DetailView(uuid: uuid)
                    .navigationTransition(.zoom(sourceID: uuid, in: namespace))
            }
        }
    }
}

struct memoryCard: View {
    let image: Data
    let location: String
    
//    @State private var isPressed = false
    
    var body: some View{
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: UIImage(data: image)!)
                .resizable().scaledToFill()
                .frame(width: 360, height: 360)
                .clipShape(Rectangle())
            HStack {
                Image(systemName: "location.fill")
                    .padding(.leading, 8)
                    .foregroundColor(.primary)
                Text(location)
                    .padding(.trailing, 8)
                    .foregroundColor(.primary)
            }
            .frame(height: 32)
            .background(.regularMaterial)
            .cornerRadius(8)
            .padding([.leading, .bottom], 8)
        }
        .frame(width: 360, height: 360)
        .clipShape(Rectangle())
        .cornerRadius(16)
//        .onLongPressGesture(minimumDuration: 0, perform: {}, onPressingChanged: { pressing in
//            withAnimation(.spring){
//                isPressed = pressing
//            }
//        })
//        .buttonStyle(disableDefaultAnim())
//        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
}

func convertDate(date: Date, scheme: String = "YYYYMM") -> String {
    let dateFormmater = DateFormatter()
    dateFormmater.dateFormat = scheme
    return dateFormmater.string(from: date)
}

#Preview{
    HistoryView()
//    memoryCard(image: "", location: "a")
}
