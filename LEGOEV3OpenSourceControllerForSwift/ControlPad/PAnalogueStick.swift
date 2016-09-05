//
//  PAnalogueStick.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

protocol PAnalogueStickDelegate {
    func analogueStickDidChangeValue(analogueStick:PAnalogueStick)
}

class PAnalogueStick: UIView {

    var delegate:PAnalogueStickDelegate?
    var xValue:CGFloat?
    var yValue:CGFloat?
    var invertedYAxis:Bool?
    var backgroundImageView:UIImageView?
    var handleImageView:UIImageView?

    var RADIUS:CGFloat?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        RADIUS = self.bounds.size.width/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit()
    {
        backgroundImageView = UIImageView.init(image: UIImage.init(named: "analogue_bg"))
        var backgroundImageFrame:CGRect = (backgroundImageView?.frame)!
        backgroundImageFrame.size = self.bounds.size
        backgroundImageFrame.origin = CGPointZero
        backgroundImageView?.frame = backgroundImageFrame
        self.addSubview(backgroundImageView!)

        handleImageView = UIImageView.init(image: UIImage.init(named: "analogue_handle"))
        var handleImageFrame:CGRect = (handleImageView?.frame)!
        handleImageFrame.size = CGSizeMake(backgroundImageView!.bounds.width/1.5, backgroundImageView!.bounds.height/1.5)
        handleImageFrame.origin = CGPointMake((self.bounds.size.width - handleImageFrame.size.width) / 2, (self.bounds.size.height - handleImageFrame.size.height) / 2)
        handleImageView?.frame = handleImageFrame
        self.addSubview(handleImageView!)

        xValue = 0
        yValue = 0
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var location:CGPoint = touches.first!.locationInView(self)
        var normalisedX = location.x/RADIUS!-1
        var normalisedY = (location.y/RADIUS!-1) * (-1)

        if normalisedX > 1 {
            location.x = self.bounds.size.width
            normalisedX = 1
        }
        else if (normalisedX < (-1))
        {
            location.x = 0
            normalisedX = (-1)
        }

        if normalisedY > 1 {
            location.y = 0
            normalisedX = 1
        }
        else if (normalisedX < (-1))
        {
            location.y = self.bounds.size.height
            normalisedY = (-1)
        }

        if (invertedYAxis != nil) {
            normalisedY *= (-1)
        }

        xValue = normalisedX
        yValue = normalisedY

        var handleImageFrame:CGRect = (handleImageView?.frame)!
        handleImageFrame.origin = CGPointMake(location.x - (handleImageView!.bounds.size.width / 2),location.y - (handleImageView!.bounds.size.width / 2))
        handleImageView?.frame = handleImageFrame

        if (delegate != nil) {
            delegate?.analogueStickDidChangeValue(self)
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var location:CGPoint = touches.first!.locationInView(self)
        var normalisedX = location.x/RADIUS!-1
        var normalisedY = (location.y/RADIUS!-1) * (-1)

        if normalisedX > 1 {
            location.x = self.bounds.size.width
            normalisedX = 1
        }
        else if (normalisedX < (-1))
        {
            location.x = 0
            normalisedX = (-1)
        }

        if normalisedY > 1 {
            location.y = 0
            normalisedX = 1
        }
        else if (normalisedX < (-1))
        {
            location.y = self.bounds.size.height
            normalisedY = (-1)
        }

        if (invertedYAxis != nil) {
            normalisedY *= (-1)
        }

        xValue = normalisedX
        yValue = normalisedY

        var handleImageFrame:CGRect = (handleImageView?.frame)!
        handleImageFrame.origin = CGPointMake(location.x - (handleImageView!.bounds.size.width / 2),location.y - (handleImageView!.bounds.size.width / 2))
        handleImageView?.frame = handleImageFrame

        if (delegate != nil) {
            delegate?.analogueStickDidChangeValue(self)
        }
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        xValue = 0
        yValue = 0

        var handleImageFrame:CGRect = (handleImageView?.frame)!
        handleImageFrame.origin = CGPointMake(self.bounds.size.width - (handleImageView!.bounds.size.width / 2),self.bounds.size.height - (handleImageView!.bounds.size.width / 2))
        handleImageView?.frame = handleImageFrame
        if (delegate != nil) {
            delegate?.analogueStickDidChangeValue(self)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        xValue = 0
        yValue = 0

        var handleImageFrame:CGRect = (handleImageView?.frame)!
        handleImageFrame.origin = CGPointMake(self.bounds.size.width - (handleImageView!.bounds.size.width / 2),self.bounds.size.height - (handleImageView!.bounds.size.width / 2))
        handleImageView?.frame = handleImageFrame
        if (delegate != nil) {
            delegate?.analogueStickDidChangeValue(self)
        }
    }
}
