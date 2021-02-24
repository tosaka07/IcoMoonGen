//
//  GenerateCommand.swift
//  ArgumentParser
//
//  Created by 坂上 翔悟 on 2021/02/22.
//

import Foundation
import ArgumentParser
import PathKit
import Stencil
import StencilSwiftKit
import ZIPFoundation
import Rainbow
import Yams

let aaaa = """
code:
  - templateName: swift
    output: output.swift
  - templatePath: temp.yml
    output: output2.swift
font:
  - fontType: ttf, woff, svg, eot
    output: some.ttf
"""

struct Spec: Codable {
    var code: [CodeOutput] = []
    var font: [FontOutput] = []

    func validate() throws {
        if code.isEmpty, font.isEmpty {
            throw ValidationError("どっちかは定義してね")
        }
        if !code.isEmpty {
            try code.forEach { try $0.validate() }
        }
    }
}

enum Template: String, Codable {
    case swift, kotlin

    func template() -> String {
        switch self {
        case .swift:
            return swiftTemplate
        case .kotlin:
            return swiftTemplate
        }
    }
}

struct CodeOutput: Codable {
    var templateName: Template?
    var templatePath: String?
    var output: String

    func validate() throws {
        if templateName == nil, templatePath == nil {
            throw ValidationError("どっちかは定義してね")
        }
    }

    func template() throws -> String {
        if let templateName = templateName {
            return templateName.template()
        }
        if let templatePath = templatePath {
            let path = Path.current + templatePath
            return try path.read(.utf8)
        }
        throw ValidationError("どっちかは定義してね")
    }
}

struct FontOutput: Codable {
    var type: FontType
    var output: String
}

enum FontType: String, Codable {
    case ttf, woff, svg, eot
}

struct GenerateCommand: ParsableCommand {

    static var configuration = CommandConfiguration(commandName: "generate")

    static let defaultSpecPath = Path("icomoongen.yml")

    @Argument(help: "")
    var input: String

    @Option(name: .shortAndLong, help: "")
    var spec: String = "icomoongen.yml"

    @Flag(name: .shortAndLong, help: "")
    var verbose: Bool = false

    func run() throws {
        // Load Spec
        let specPath = Path.current + self.spec
        if !specPath.exists {
            throw ValidationError("spec がないよ")
        }
        let spec = try loadSpec(path: specPath)
        try spec.validate()


        // Load zip
        let inputPath = Path.current + input
        let zipData = try inputPath.read()

        guard let archive = Archive(data: zipData, accessMode: .read) else {
            throw ValidationError("アーカイブ作成できませんでした。")
        }

        // Load svg
        let svgEntry = try archive.entry(pathExtension: "svg")
        let svgData = try archive.extract(svgEntry)
        guard let svgString = String(data: svgData, encoding: .utf8) else {
            throw ValidationError("svg ファイルをパースできません")
        }
        let glyphs = try IcoMoonSvgParser.parse(svgString)
        let context: [String: Any] = [
            "name": glyphs.name,
            "glyphs": glyphs.glyphs
        ]
        let environment = stencilSwiftEnvironment()

        // generate code and export
        try spec.code.forEach { codeOutput in
            let rendered = try environment.renderTemplate(string: codeOutput.template(), context: context)
            try Path(codeOutput.output).write(rendered)
        }

        // move font
        try spec.font.forEach { fontOutput in
            let data = try archive.extract(archive.entry(pathExtension: fontOutput.type.rawValue))
            try Path(fontOutput.output).write(data)
        }
    }

    func loadSpec(path: Path) throws -> Spec {
        guard path.exists else {
            throw ValidationError("Not exists a spec file \(path.absolute())")
        }

        if verbose {
            print("Spec exists here! \(path)")
        }

        let data = try path.read()
        let decoder = YAMLDecoder()
        return try decoder.decode(Spec.self, from: data)
    }
}

extension Archive {
    func entry(pathExtension: String) throws -> Entry {
        guard let entry = self
            .first(where: { entry in
                let url = URL(string: entry.path)
                return url?.pathExtension == pathExtension
            })
        else { throw ValidationError("\(pathExtension)ファイルがみつかりません") }
        return entry
    }

    func extract(_ entry: Entry, bufferSize: UInt32 = defaultReadChunkSize, skipCRC32: Bool = false, progress: Progress? = nil) throws -> Data {
        var data = Data()
        _ = try self.extract(entry, bufferSize: bufferSize, skipCRC32: skipCRC32, progress: progress) { (resultData) in
            data.append(resultData)
        }
        return data
    }
}
