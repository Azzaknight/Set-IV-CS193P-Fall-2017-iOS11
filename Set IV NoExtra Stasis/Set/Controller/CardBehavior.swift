//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by CS193p Instructor on 10/18/17.
//  Copyright © 2017 CS193p Instructor. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior
{
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 0.9
        behavior.resistance = 0.1
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = CGFloat.pi*3/4 - (CGFloat.pi*2).arc4random
        push.magnitude = CGFloat(10.0) + CGFloat(2.0).arc4random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    var snapPoint = CGPoint()
    
    private func snap(_ item: UIDynamicItem) {
        let snap = UISnapBehavior(item: item, snapTo: snapPoint)
            snap.damping = 0.2
            addChildBehavior(snap)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.collisionBehavior.removeItem(item)
            self.snap(item)
        }
        push(item)
    }
    
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
