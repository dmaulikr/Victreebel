//
//  RadialMenuNode.swift
//  chainio
//
//  Created by Francis Beauchamp on 2017-07-15.
//  Copyright © 2017 Francis Beauchamp. All rights reserved.
//

import SpriteKit

protocol RadialMenuNodeData {
    var texture: String { get }
    var action: (() -> Void)? { get }
}

protocol RadialMenuNodeDelegate: class {
    func didSelect(menuNode: RadialMenuNode)
}

class RadialMenuNode: SKCropNode {
    weak var delegate: RadialMenuNodeDelegate?

    private let action: (() -> Void)?
    init(texture: String, action: (() -> Void)? = nil) {
        self.action = action
        super.init()
        let mask = SKShapeNode(circleOfRadius: 15)
        mask.fillColor = .red
        maskNode = mask
        xScale = 0
        yScale = 0
        zPosition = 999999
        isUserInteractionEnabled = true
        let texture: SKTexture = SKTexture(imageNamed: texture)
        let child = SKSpriteNode(texture: texture, color: .clear, size: CGSize(width: 20, height: 20))
        addChild(child)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animate(towards point: CGPoint, scalingFactor: CGFloat) {
        run(SKAction.group([
            SKAction.move(to: point, duration: 0.3),
            SKAction.scaleX(to: scalingFactor, y: scalingFactor, duration: 0.3)
        ]))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        action?()
        delegate?.didSelect(menuNode: self)
    }
}
