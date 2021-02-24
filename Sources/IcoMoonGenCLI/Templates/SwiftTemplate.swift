//
//  SwiftTemplate.swift
//  ArgumentParser
//
//  Created by 坂上 翔悟 on 2021/02/23.
//

let swiftTemplate = """
// swiftlint:disable all
// Generated using IcoMoonGen — https://github.com/tosaka07/IcoMoonGen

public enum Icon: String, CaseIterable {
    {% for glyph in glyphs %}case {{ glyph.name | snakeToCamelCase | lowerFirstLetter | escapeReservedKeywords }}
    {% endfor %}

    var name: String {
        return rawValue
    }

    var code: UInt32 {
        switch self {
        {% for glyph in glyphs %}case .{{ glyph.name | snakeToCamelCase | lowerFirstLetter | escapeReservedKeywords }}: return {{ glyph.unicode }}
        {% endfor %}}
    }
}
"""
