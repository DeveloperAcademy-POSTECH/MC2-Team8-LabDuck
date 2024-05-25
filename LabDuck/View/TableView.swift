//
//  TableView.swift
//  LabDuck
//
//  Created by hanseoyoung on 5/13/24.
//

import SwiftUI

struct TableView: View {
    @Binding var board: KPBoard
    @Binding var searchText: String
    @State private var expanded: Bool = true
    @State private var selection = Set<KPNode.ID>()
    @State private var sortOrder = [KeyPathComparator(\KPNode.title)]
    @State private var isSheet: Bool = false
    @State private var editingNode: KPNode = KPNode()
    @State private var editingNodeID: KPNode.ID?
    
    var body: some View {
        VStack{
            Table(of: KPNode.self, selection: $selection, sortOrder: $sortOrder) {
                TableColumn("Color", value: \.colorTheme.rawValue)
                { node in
                    ZStack {
                        Rectangle()
                            .frame(width: 18, height: 18)
                            .cornerRadius(5)
                            .foregroundColor(node.colorTheme.backgroundColor)
                            .padding(4)
                            .onTapGesture(count: 2) {
                                editingNodeID = node.id
                                isSheet = true
                            }
                        if node.colorTheme == KPColorTheme.default {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.black.opacity(0.1), lineWidth: 1)
                                .frame(width: 18, height: 18)
                                .padding(4)
                        }
                    }
                }
                .width(77)
                
                TableColumn("Title", value: \.unwrappedTitle) { node in
                    if let _ = node.title {
                        styledText(node.unwrappedTitle, node: node)
                    } else {
                        styledText(node.unwrappedTitle, node: node)
                            .foregroundColor(.secondary)
                    }
                }.width(min: 100)
                
                TableColumn("Note", value: \.unwrappedNote) { node in
                    styledText(node.unwrappedNote, node: node)
                }
                
                TableColumn("Tags") { node in
                    ScrollView(.horizontal) {
                        HStack() {
                            ForEach(node.tags) { tag in
                                Button(action: {
                                    editingNodeID = node.id
                                    isSheet = true
                                }) {
                                    Text("#\(tag.name)")
                                        .font(.system(size: 13.0))
                                        .foregroundColor(.white)
                                        .fontWeight(.semibold)
                                        .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
                                        .background(tag.colorTheme.backgroundColor)
                                        .cornerRadius(6)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        .padding([.leading, .trailing], 10)
                    }
                    .scrollIndicators(.hidden)
                }
                
                TableColumn("URL", value: \.unwrappedURL) { node in
                    Link(destination: URL(string: node.url ?? " ")!, label: {
                        styledText(node.unwrappedURL, node: node)
                            .underline()
                    })
                }
                
            } rows: {
                ForEach(filteredNodes, id: \.id) { node in
                    if findNodes(matching: node).isEmpty {
                        TableRow(node)
                    } else {
                        DisclosureTableRow(node) {
                            ForEach(findNodes(matching: node).sorted(using: sortOrder)) { subNode in
                                TableRow(subNode)
                            }
                        }
                    }
                }
            }
            .tableStyle(.inset(alternatesRowBackgrounds: false))
            .scrollContentBackground(.hidden)
            .onChange(of: sortOrder) { _, newSortOrder in
                board.nodes.sort(using: newSortOrder)}
            .onChange(of: selection) { _, newSelection in
                updateSelection(newSelection: newSelection)}
            .searchable(text: $searchText)
            .inspector(isPresented: $isSheet) {
                if let editingNodeID = editingNodeID, let editingNodeIndex = board.nodes.firstIndex(where: { $0.id == editingNodeID }) {
                    EditSheetView(node: $board.nodes[editingNodeIndex], board: $board, isSheet: $isSheet,selection: $selection, findNodes: findNodes)
                        .inspectorColumnWidth(min: 320, ideal: 320, max: 900)
                }
                
            }
            
        }
    }
    
    // MARK: - 노드의 ouputPoint에 대한 inputPoint들을 찾아 해당 노드들 리턴
    func findNodes(matching node: KPNode) -> [KPNode] {
        let sourceIDs = node.outputPoints.map { $0.id }
        
        let matchingSinkIDs = board.edges.filter { sourceIDs.contains($0.sourceID) }.map { $0.sinkID }
        
        var nodeDict = [UUID: KPNode]()
        
        board.nodes.forEach { node in
            node.inputPoints.forEach { inputPoint in
                if matchingSinkIDs.contains(inputPoint.id) {
                    nodeDict[node.id] = node
                }
            }
        }
        
        return Array(nodeDict.values)
    }
    
    // MARK: - selection된 리스트를 받아서 같은 id인 것들을 업데이트
    func updateSelection(newSelection: Set<KPNode.ID>) {
        var allSelectedIDs = newSelection
        
        newSelection.forEach { nodeID in
            if let node = board.nodes.first(where: { $0.id == nodeID }) {
                allSelectedIDs.insert(node.id)
            }
        }
        
        selection = allSelectedIDs
    }
    
    // MARK: - 필터링 기능
    var filteredNodes: [KPNode] {
        if searchText.isEmpty {
            return board.nodes
        } else {
            return board.nodes.filter { node in
                let titleMatch = node.unwrappedTitle.lowercased().contains(searchText.lowercased())
                let tagsMatch = node.tags.map { ("#" + $0.name).lowercased() }.contains { $0.contains(searchText.lowercased()) }
                let urlMatch = node.unwrappedURL.lowercased().contains(searchText.lowercased())
                let noteMatch = node.unwrappedNote.lowercased().contains(searchText.lowercased())
                
                return titleMatch || tagsMatch || urlMatch || noteMatch
            }
        }
    }
    
    func styledText(_ text: String, node: KPNode) -> some View {
        return Text(text)
            .font(.system(size: 13.0))
            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
            .lineLimit(1)
            .onTapGesture(count: 2) {
                editingNodeID = node.id
                isSheet = true
            }
    }
}


    
#Preview {
    TableView(board: .constant(.mockData), searchText: .constant(""))
}
