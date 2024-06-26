//
//  KPNode.swift
//  LabDuck
//
//  Created by 정종인 on 5/13/24.
//

import Foundation

struct KPNode: Identifiable, Equatable, Codable, Hashable {
    var id: UUID
    var title: String?
    var note: String?
    var url: String?
    var tags: [KPTag.ID] = []
    var colorTheme: KPColorTheme = .default
    var position: CGPoint {
            didSet {
                position.x = min(max(position.x, -2300), 2300)
                position.y = min(max(position.y, -1800), 1800)
            }
        }
    var size: CGSize {
            didSet {
                size.width = min(max(size.width, 320), 612)
            }
        }
    var inputPoints: [KPInputPoint] = []
    var outputPoints: [KPOutputPoint] = []

    init(id: UUID = UUID(), title: String? = nil, note: String? = nil, url: String? = nil, tags: [KPTag.ID] = [], colorTheme: KPColorTheme = .default, position: CGPoint = .zero, size: CGSize = CGSize(width: 400, height: 400), inputPoints: [KPInputPoint] = [], outputPoints: [KPOutputPoint] = []) {
        self.id = UUID()
        self.title = title
        self.note = note
        self.url = url
        self.tags = tags
        self.colorTheme = colorTheme
        self.position = position
        self.size = size
        self.inputPoints = inputPoints.isEmpty ? (0..<3).map { _ in KPInputPoint(ownerNode: self.id) } : inputPoints.map { inputPoint in
            KPInputPoint(id: inputPoint.id, name: inputPoint.name, ownerNode: self.id)
        }
        self.outputPoints = outputPoints.isEmpty ? (0..<3).map { _ in KPOutputPoint(ownerNode: self.id) } : outputPoints.map { outputPoint in
            KPOutputPoint(id: outputPoint.id, name: outputPoint.name, ownerNode: self.id)
        }
    }
}

extension KPNode {
    var unwrappedTitle: String {
        get {
            self.title ?? "Untitled"
        }
        set {
            self.title = newValue
        }
    }
    var unwrappedNote: String {
        get {
            self.note ?? ""
        }
        set {
            self.note = newValue
        }
    }
    var unwrappedURL: String {
        get {
            self.url ?? ""
        }
        set {
            self.url = newValue
        }
    }
}

extension KPNode {
    static var mockData: KPNode {
        KPNode(
            title: "title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1",
            note: "note1note1note1note1note1note1note1note1note1note1note1note1note1note1note1",
            url: "https://www.naver.com",
            tags: [KPTag.mockData.id, KPTag.mockData1.id, KPTag.mockData2.id],
            colorTheme: .blue,
            position: .init(x: 50, y: 20),
            inputPoints: .mockData,
            outputPoints: .mockData
        )
    }
    static var mockData2: KPNode {
        KPNode(
            title: "title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1title1",
            note: "",
            url: "",
            tags: [KPTag.mockData.id, KPTag.mockData1.id, KPTag.mockData2.id],
            colorTheme: .blue,
            position: .init(x: 50, y: 20),
            inputPoints: .mockData,
            outputPoints: .mockData
        )
    }
}

extension Array where Element == KPNode {
    static var mockData: [Element] = [
        .init(
            title: "Thrilled by Your Progress! Large Language Models (GPT-4) No Longer Struggle to Pass Assessments in Higher Education Programming Courses",
            note: "Related work 살펴보기 좋을듯 Related work 살펴보기 좋을듯 Related work 살펴보기 좋을듯 Related work 살펴보기 좋을듯 Related work 살펴보기 좋을듯 Related work 살펴보기 좋을듯",
            url: "https://arxiv.org/pdf/2306.10073.pdf",
            tags: [KPTag.mockData.id, KPTag.mockData1.id],
            colorTheme: .blue,
            position: .init(x: 50, y: 20),
            inputPoints: .mockData,
            outputPoints: .mockData
        ),
        .init(
            title: "Cracking the code: Co-coding with AI in creative programming education",
            url: "https://dl.acm.org/doi/abs/10.1145/3527927.3532801",
            position: .init(x: 80, y: 40),
            inputPoints: .mockData,
            outputPoints: .mockData
        ),
        .init(
            title: "AlgoSolve: Supporting Subgoal Learning in Algorithmic Problem-Solving with Learnersourced Microtasks",
            note: "Related work 살펴보기 좋을듯",
            url: "https://kixlab.github.io/website-files/2022/chi2022-AlgoSolve-paper.pdf",
            position: .init(x: 110, y: 30),
            inputPoints: .mockData,
            outputPoints: .mockData
        ),
        .init(
            title: "Supporting programming and learning-to-program with an integrated CAD and scaffolding workbench",
            tags: [KPTag.mockData.id],
            position: .init(x: 140, y: 60),
            inputPoints: .mockData,
            outputPoints: .mockData
        ),
        .init(
            title: "Robust and Scalable Online Code Execution System",
            note: "Judge0 - code execution system",
            url: "https://ieeexplore.ieee.org/document/9245310",
            tags: [KPTag.mockData.id, KPTag.mockData2.id],
            position: .init(x: 170, y: 70),
            inputPoints: .mockData,
            outputPoints: .mockData
        ),
        .init(
            note: "이름없는노드다.",
            tags: [KPTag.mockData.id, KPTag.mockData2.id],
            position: .init(x: 170, y: 70),
            inputPoints: .mockData,
            outputPoints: .mockData
        ),
    ]
}
