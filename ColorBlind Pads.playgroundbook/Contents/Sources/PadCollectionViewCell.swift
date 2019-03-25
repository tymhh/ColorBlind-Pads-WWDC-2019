//
//  PadCollectionViewCell.swift
//  Book_Sources
//
//  Created by Tim on 3/17/19.
//

import UIKit

class PadCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var padButton: PadButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowOffset = CGSize(width: -1, height: -1)
        layer.shadowColor = UIColor.white.withAlphaComponent(0.6).cgColor
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
        layer.masksToBounds = true
        imageView.tag = 513
    }
    
    func pulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0.2
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        imageView.layer.add(pulseAnimation, forKey: nil)
    }
    
    func stopAnimation() {
        imageView.layer.removeAllAnimations()
    }
}
