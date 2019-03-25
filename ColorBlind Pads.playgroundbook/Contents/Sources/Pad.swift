//
//  Pad.swift
//  Book_Sources
//
//  Created by Tim on 3/17/19.
//

import Foundation

public class Pad: Codable {
    var soundName: Sound
    var soundURL: URL?
    var symbol: Color
    
    public init(sound: Sound, color: Color) {
        symbol = color
        soundName = sound
        soundURL = Bundle.main.url(forResource: soundName.rawValue, withExtension: "wav")
    }
    
    enum CodingKeys: String, CodingKey {
        case soundName
        case symbol
    }
    
    // MARK: - Codable
    required public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(Sound.self, forKey: .soundName)
        let symbol = try container.decode(Color.self, forKey: .symbol)
        self.init(sound: name, color: symbol)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(soundName, forKey: .soundName)
        try container.encode(symbol, forKey: .symbol)
    }
}
