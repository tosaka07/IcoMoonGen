//
//  IcoMoonSvgParser.swift
//  ArgumentParser
//
//  Created by 坂上 翔悟 on 2021/02/22.
//

import Foundation
import SwiftSoup

struct Glyph {
    let name: String
    let unicode: UInt32
}

struct Glyphs {
    let name: String
    let glyphs: [Glyph]
}

enum IcoMoonSvgParser {
    static func parse(_ raw: String) throws -> Glyphs {
        let doc = try SwiftSoup.parse(raw)

        let fontName = try doc.select("font").first()?.attr("id") ?? ""
        let glyphs = try doc.select("glyph")
            .compactMap { (elm: Element) -> Glyph? in
                if elm.hasAttr("unicode"),
                   elm.hasAttr("glyph-name"),
                   let unicode = (try elm.attr("unicode")).unicodeScalars.first?.value {
                    return Glyph(
                        name: try elm.attr("glyph-name")
                            .replacingOccurrences(of: "-", with: "_"),
                        unicode: unicode
                    )
                }
                return nil
            }

        return Glyphs(
            name: fontName,
            glyphs: glyphs
        )
    }
}
