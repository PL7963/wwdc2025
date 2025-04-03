import SwiftUI
import SwiftData

struct HighlightView: View {
    @Query private var memories: [Memory]
    
    var groupedMemories: [String: [Memory]] {
        Dictionary(grouping: memories) { memory in
            return convertDate(date: memory.date)
        }
    }
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                if(memories.count == 0) {
                    Card(
                        title: "Add your first Memory", 
                         mode: Mode.getStart, 
                        count: 0,
                        image: UIImage(named: "AddYourFirstMemory")!
                    )
                } else {
                    ForEach(groupedMemories.keys.sorted(by: >), id: \.self) { key in
                        if let memories = groupedMemories[key],
                           let firstMem = memories.first {
                            if(memories.count > 4) {
                                Card(
                                    title: "Memories at \(convertDate(date: firstMem.date, scheme: "MMMM"))", 
                                    mode: Mode.time, 
                                    count: memories.count, 
                                    image: UIImage(data: memories.first!.photo)!,
                                    startDate: memories.first?.date.advanced(by: -1), 
                                    endDate: memories.last?.date.advanced(by: 1))
                            }
                        }   
                    }
                    Card(
                        title: "Memories of all time", 
                        mode: .time, 
                        count: memories.count, 
                        image: UIImage(data: memories.first!.photo)!,
                        startDate: Date(timeIntervalSince1970: 0), 
                        endDate: Date())
                }
            }
        }
        .contentMargins(.horizontal, 16)
    }
}

struct Card: View{
    let title: String
    let mode: Mode
    let count: Int
    let image: UIImage
    let startDate: Date?
    let endDate: Date?
    let location: String?
    
    let width: CGFloat = 512
    let height: CGFloat = 400
    
    init(title: String, mode: Mode, count: Int, image: UIImage, startDate: Date? = nil, endDate: Date? = nil, location: String? = nil) {
        self.title = title
        self.mode = mode
        self.count = count
        self.image = image
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
    }
    
    @Namespace private var namespace
    @State private var scaleValue = 1.0
    @State private var isPressed = false
    
    var body: some View{
        NavigationLink {
            if(count > 0) {
                RewindView(mode: mode, startDate: startDate, endDate: endDate, location: location)
                    .navigationTransition(.zoom(sourceID: title, in: namespace))
            } else {
                Text("Add memories by tapping add button at home screen")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.primary)
                    .font(.title)
                    .bold()
            }
        } label: {
            ZStack(alignment: .bottom) {
                Image(uiImage: image)
                    .resizable().scaledToFill()
                    .frame(width: width, height: height)
                VStack(alignment: .leading){
                    Text(title)
                        .bold().font(.largeTitle)
                        .padding(EdgeInsets(top: 16, leading:8, bottom: 0, trailing: 0))
                        .foregroundColor(.white)
                    Spacer()
                    HStack(alignment: .center) {
                        Image(systemName: "photo.stack").foregroundStyle(.secondary)
                        Text("\(count) Memories")
                            .foregroundStyle(.secondary)
                    }.padding(EdgeInsets(top: 0, leading:8, bottom: 16, trailing: 0))
                }
                .frame(maxWidth: .infinity, maxHeight: 96, alignment: .leading)
                .background(.thinMaterial)
                .environment(\.colorScheme, .dark)
            }
            .matchedTransitionSource(id: title, in: namespace)
            .cornerRadius(16)
        } 
        .onLongPressGesture(minimumDuration: 0, perform: {}, onPressingChanged: { pressing in
            withAnimation(.spring){
                isPressed = pressing
            }
        })
        .buttonStyle(disableDefaultAnim())
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
}

struct disableDefaultAnim: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

#Preview {
    HighlightView()
//    Card()
}
