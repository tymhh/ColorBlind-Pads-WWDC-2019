//
//  BindColor.swift
//  Book_Sources
//
//  Created by Tim on 3/19/19.
//

import Foundation
import UIKit

typealias RGB = (red: Int, green: Int, blue: Int)

public enum ColorBlindType: String, Codable {
    case none
    case deuteranomaly
    case deuteranopia
    case protanomaly
    case protanopia
    case tritanomaly
    case tritanopia
    case achromatomaly
    case achromatopsia
}

enum Deficiency {
    case protan
    case deutan
    case tritan
    
    typealias DeficiencyData = (cpu: Double, cpv: Double, am: Double, ayi: Double)
    
    var values: DeficiencyData {
        switch self {
        case .protan:
            return DeficiencyData(cpu: 0.735, cpv: 0.265, am: 1.273463, ayi: -0.073894)
        case .deutan:
            return DeficiencyData(cpu: 1.14, cpv: -0.14, am: 0.968437, ayi: 0.003331)
        case .tritan:
            return DeficiencyData(cpu: 0.171, cpv: -0.003, am: 0.062921, ayi: 0.292119)
        }
    }
}

public enum Color: String, Codable {
    case green
    case lightPurple
    case red
    case orange
    
    var uiColor: UIColor {
        switch self {
        case .green:
            return .userGreen
        case .lightPurple:
            return .userPink
        case .red:
            return .userRed
        case .orange:
            return .userOrange
        }
    }
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
    
    func inclusive(for type: ColorBlindType) -> UIColor {
        guard let color = rgba(self.uiColor) else { return .gray }
        
        switch type {
        case .none:
            return rgbToUIColor(color)
        case .protanopia:
            return rgbToUIColor(blindMK(color, deficiency: .protan))
        case .protanomaly:
            return rgbToUIColor(anomylize(color, adjusted: (blindMK(color, deficiency: .protan))))
        case .deuteranopia:
            return rgbToUIColor(blindMK(color, deficiency: .deutan))
        case .deuteranomaly:
            return rgbToUIColor(anomylize(color, adjusted: (blindMK(color, deficiency: .deutan))))
        case .tritanopia:
            return rgbToUIColor(blindMK(color, deficiency: .tritan))
        case .tritanomaly:
            return rgbToUIColor(anomylize(color, adjusted: (blindMK(color, deficiency: .tritan))))
        case .achromatopsia:
            return rgbToUIColor(monochrome(color))
        case .achromatomaly:
            return rgbToUIColor(anomylize(color, adjusted: (monochrome(color))))
        }
    }
    
    func rgba(_ color: UIColor) -> RGB? {
        var redLiteral: CGFloat = 0
        var greenLiteral: CGFloat = 0
        var blueLiteral: CGFloat = 0
        var alphaLiteral: CGFloat = 0
        
        guard color.getRed(&redLiteral,
                           green: &greenLiteral,
                           blue: &blueLiteral,
                           alpha: &alphaLiteral) else { return nil }
        
        return (Int(redLiteral * 255), Int(greenLiteral * 255), Int(blueLiteral * 255))
    }
    
    var gammaPowerLookupTable: [Double] {
        var array = [Double]()
        for index in 0..<256 {
            array.append(pow((Double(index) / 255.0), 2.2))
        }
        return array
    }
    
    func anomylize(_ rgb: RGB, adjusted: RGB) -> RGB {
        let v = 1.75
        let d = v * 1 + 1
        
        return (Int((v * Double(adjusted.0) + Double(rgb.0) * 1) / d),
                Int((v * Double(adjusted.1) + Double(rgb.1) * 1) / d),
                Int((v * Double(adjusted.2) + Double(rgb.2) * 1) / d))
    }
    
    func inversePow(_ num: Double) -> Double {
        return (255 * (num <= 0 ? 0 : num >= 1 ? 1 : pow(num, 1 / 2.2)))
    }
    
    func monochrome(_ rgb: RGB) -> RGB {
        let z = Int(round(Double(rgb.0) * 0.299 + Double(rgb.1) * 0.587 + Double(rgb.2) * 0.114))
        return (z, z, z)
    }
    
    func blindMK(_ rgb: RGB, deficiency: Deficiency) -> RGB {
        let wx = 0.312713
        let wy = 0.329016
        let wz = 0.358271
        
        let cr = gammaPowerLookupTable[rgb.0]
        let cg = gammaPowerLookupTable[rgb.1]
        let cb = gammaPowerLookupTable[rgb.2]
        
        let cx = (0.430574 * cr + 0.341550 * cg + 0.178325 * cb)
        let cy = (0.222015 * cr + 0.706655 * cg + 0.071330 * cb)
        let cz = (0.020183 * cr + 0.129553 * cg + 0.939180 * cb)
        
        let sumXYZ = cx + cy + cz
        
        let cu: Double
        let cv: Double
        if (sumXYZ != 0) {
            cu = cx / sumXYZ
            cv = cy / sumXYZ
        } else {
            cu = 0
            cv = 0
        }
        
        let nx = wx * cy / wy
        let nz = wz * cy / wy
        let clm: Double
        let dy = 0.0
        
        if (cu < deficiency.values.cpu) {
            clm = (deficiency.values.cpv - cv) / (deficiency.values.cpu - cu)
        } else {
            clm = (cv - deficiency.values.cpv) / (cu - deficiency.values.cpu)
        }
        
        let clyi = cv - cu * clm
        let du = (deficiency.values.ayi - clyi) / (clm - deficiency.values.am)
        let dv = (clm * du) + clyi
        
        let sx = du * cy / dv
        let sy = cy
        let sz = (1 - (du + dv)) * cy / dv
        
        var sr: Double =  (3.063218 * sx - 1.393325 * sy - 0.475802 * sz)
        var sg: Double = (-0.969243 * sx + 1.875966 * sy + 0.041555 * sz)
        var sb: Double =  (0.067871 * sx - 0.228834 * sy + 1.069251 * sz)
        
        let dx = nx - sx
        let dz = nz - sz
        
        let dr =  (3.063218 * dx - 1.393325 * dy - 0.475802 * dz)
        let dg = (-0.969243 * dx + 1.875966 * dy + 0.041555 * dz)
        let db =  (0.067871 * dx - 0.228834 * dy + 1.069251 * dz)
        
        let adjr: Double = dr > 0 ? ((sr < 0 ? 0 : 1) - sr) / dr : 0.0
        let adjg: Double = dg > 0 ? ((sg < 0 ? 0 : 1) - sg) / dg : 0.0
        let adjb: Double = db > 0 ? ((sb < 0 ? 0 : 1) - sb) / db : 0.0
        
        let adjust = max(((adjr > 1 || adjr < 0) ? 0 : adjr), ((adjg > 1 || adjg < 0) ? 0 : adjg), ((adjb > 1 || adjb < 0) ? 0 : adjb))
        
        sr = sr + (adjust * dr)
        sg = sg + (adjust * dg)
        sb = sb + (adjust * db)
        
        return (Int(inversePow(sr)), Int(inversePow(sg)), Int(inversePow(sb)))
    }
    
    func rgbToUIColor(_ rgb: RGB) -> UIColor {
        let red = CGFloat(rgb.0) / 255.0
        let green = CGFloat(rgb.1) / 255.0
        let blue = CGFloat(rgb.2) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
