import SwiftUI

struct BoardGallery: View {
    @State var boards: [KPBoard] = [.mockData, .mockData, .mockData, .mockData, .mockData, .mockData, .mockData]
    
    let columns = [
        GridItem(.adaptive(minimum: 240), spacing: 10)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("All files")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading, 40)
                LazyVGrid(columns: columns) {
                    ForEach($boards, id: \.id) { $board in
                        BoardView(board: $board)
                    }
                }
                .padding(.horizontal, 20)
                .background(Color.green)
            }
            .padding(.top, 40)
            
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

#Preview {
    BoardGallery()
}