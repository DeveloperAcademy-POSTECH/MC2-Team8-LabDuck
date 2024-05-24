//
//  TagPOPUP.swift
//  LabDuck
//
//  Created by hanseoyoung on 5/23/24.
//

import SwiftUI

struct TagPopupView: View {
    @Binding var isEditingForTag: Bool
    @Binding var node: KPNode
    @State private var hoveredForClosingTagView: Bool = false
    @State private var textForTags: String = ""
    @State private var previewTag: KPTag?
    
    var body: some View {
        VStack (alignment:.leading,spacing: 0){
            //            ZStack{
            //                Rectangle().fill(Color.gray.opacity(0.2))
            //                    .frame(width:250, height:20)
            VStack(spacing: 0){
                HStack{
                    Spacer()
                    Button{
                        isEditingForTag = false
                    }label: {
                        Image(systemName: "xmark.circle").foregroundColor(.gray)
                            .opacity(self.hoveredForClosingTagView ? 1.0 : 0.3)
                            .onHover { hover in
                                print("Mouse hover: \(hover)")
                                self.hoveredForClosingTagView = hover
                            }
                    }.buttonStyle(BorderlessButtonStyle())
                }
                
                TextField("태그에 넣을 텍스트를 입력하세요", text: $textForTags, onCommit: {
                    addPreviewTag()
                })
                .padding(.horizontal)
                .foregroundColor(.blue)
                .background(Color.clear)
                
            }.frame(width: 250, height: 50)
                .background(.gray)
            
            
            VStack(alignment: .leading, spacing: 10){
                Text("선택된 태그").foregroundColor(.gray).font(.system(size:13)).padding(10)
            
            
            Text("태그 선택 또는 생성").foregroundColor(.gray).font(.system(size:13)).padding(10)
                
                HStack(spacing: 20){
                    
                    //태그 생성 버튼
                    Button{
                        createTag()
                        
                    }label: {
                        Text("생성").foregroundColor(.black)
                    }.buttonStyle(BorderlessButtonStyle())
                        .padding(.top, 5)
                    
                    //태그 프리뷰
                    if previewTag != nil {
                        Text("#\(textForTags)")
                            .padding(8)
                            .background(.blue)
                            .cornerRadius(6)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                        
                    }
                    Spacer()
                    
                }.background(Color.gray)
                    .frame(width: 234, height: 40)
                    .cornerRadius(6)
                    .padding(10)
            
                
                //태그 뷰의 태그 출력
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(node.tags) { tag in
                        Text("#\(tag.name)")
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                            .background(Color.blue)
                            .cornerRadius(6)
                    }
                }
            }
            .frame(width:250)
            .background(Color.white)
        }
        .cornerRadius(6)
        .shadow(radius: 10)
    }
    
    private func addPreviewTag() {
        guard !textForTags.isEmpty else { return }
        let newTagForPreview = KPTag(id: UUID(), name: textForTags, colorTheme: KPTagColor.blue)
        previewTag = newTagForPreview
    }
    
    private func createTag() {
        guard let previewTag = previewTag else { return }
        node.tags.append(previewTag)
        self.previewTag = nil
        self.textForTags = ""
    }
}