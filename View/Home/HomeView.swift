import SwiftUI
import PhotosUI

struct HomeView: View {
    @State var selectedImage: PhotosPickerItem?
    @State var isPresented: Bool = false
    @State var imageData: Data?

    var body: some View {
        ScrollView() {
            VStack() {
                HighlightView()
                HistoryView()
            }
        }
        .navigationTitle("Memories")
        .toolbar {
            ToolbarItem {
                PhotosPicker(selection: $selectedImage) {
                    Image(systemName: "plus")
                }
                .onChange(of: selectedImage) {
                    Task {
                        do {
                            imageData = try await selectedImage?.loadTransferable(type: Data.self)
                            isPresented = true
                        } catch {
                            imageData = nil
                        }
                    }
                }
                .navigationDestination(isPresented: $isPresented) {
                    AddMemoryView(uuid: nil, imageData: imageData)
                }
            }
        }
    }
}
