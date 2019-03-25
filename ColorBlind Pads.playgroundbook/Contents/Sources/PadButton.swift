//
//  PadButton.swift
//  Book_Sources
//
//  Created by Tim on 3/17/19.
//

import UIKit

protocol PadButtonRecordDelegate: class {
    func touchesBegan(_ sender: UIButton)
    func touchesEnded(_ sender: UIButton)
}

class PadButton: UIButton {
    var bgColor: UIColor?
    weak var delegate: PadButtonRecordDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            if newValue { backgroundColor = bgColor?.darker()
            } else { backgroundColor = bgColor }
            super.isHighlighted = newValue
        }
    }
    
    func configure(bgColor: UIColor, delegate: PadButtonRecordDelegate?, tag: Int) {
        backgroundColor = bgColor
        self.delegate = delegate
        self.tag = tag
        self.bgColor = bgColor
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesBegan(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touchesEnded(self)
    }
}
