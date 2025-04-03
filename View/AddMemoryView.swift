import SwiftUI
import SwiftUIFlowLayout

struct AddMemoryView: View {
    let uuid: UUID?
    let imageData: Data?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    //    @Query(filter: #Predicate<Memory> { memory in
    //        memory.uuid == UUID()
    //    }) var memory: [Memory]    
    @State var location: String = ""
    @State var date: Date = Date()
    @State var hashtags: Array<String> = []
    
    var body: some View {
        ZStack(alignment: .trailing) {
            Color.clear
                .overlay {
                    if let data = imageData {
                        Image(uiImage: UIImage(data: data)!).resizable().scaledToFill()
                    } else {
                        Image(systemName: "x.circle")
                    }
                }
            
            VStack {
                Form {
                    Section {
                        DatePicker("Date", selection: $date, displayedComponents: [.date])
                        TextField("Location", text: $location)
                    }
                    AddHashtags(hashtags: $hashtags)
                }
                .scrollContentBackground(.hidden)
                Button {
                    if(!location.isEmpty && !hashtags.isEmpty) {
                        let newMemory = Memory(date: date, hashtags: hashtags, location: location, photo: imageData!)
                        modelContext.insert(newMemory)
                        try! modelContext.save()
                        dismiss()
                    }
                } label: {
                    Text("Save")
                        .frame(width: 330)
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .background(.thickMaterial)
            .frame(width: 400, height: .infinity)
            .cornerRadius(16)
            .padding(16)
        }
    }
}

struct AddHashtags: View {
    @State var hashtagTextField: String = ""
    @Binding var hashtags: Array<String>
    
    var body: some View {
        List {
            HStack {
                TextField("Hashtag", text: $hashtagTextField).onSubmit{
                    if(!hashtagTextField.isEmpty) {
                        hashtags.append(hashtagTextField); hashtagTextField=""
                    }
                }
                Button("Add") {
                    if(!hashtagTextField.isEmpty) {
                        hashtags.append(hashtagTextField); hashtagTextField=""
                    }
                }.frame(width: 50)
            }
            FlowLayout(mode: .scrollable, items: hashtags, itemSpacing: 4) { content in
                HStack() {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 12,height: 12)
                        .foregroundStyle(.secondary)
                    Text(content)
                }
                .padding([.leading, .trailing], 8)
                .padding([.bottom, .top], 4)
                .background(.thickMaterial)
                .cornerRadius(4)
                .onTapGesture {
                    if let index = hashtags.firstIndex(of: content) {
                        hashtags.remove(at: index)
                    }
                }
            }   
        }
    }
}

#Preview {
    AddMemoryView(uuid: nil, imageData: nil)
}
