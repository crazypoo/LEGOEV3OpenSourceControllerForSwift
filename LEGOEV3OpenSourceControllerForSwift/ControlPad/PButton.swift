//
//  PButton.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

protocol PButtonDelegate {
    func buttonPressed(button:PButton)
    func buttonReleased(button:PButton)
}

class PButton: UIView {

    var delegate:PButtonDelegate?
    var titleLabel:UILabel?
    var backgroundImage:UIImage?
    var backgroundImagePressed:UIImage?
    var titleEdgeInsets:UIEdgeInsets?
    var pressed:Bool?
    var _backgroundImageView:UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInt()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInt()
    {
        _backgroundImageView = UIImageView.init(image: backgroundImage)
        _backgroundImageView?.frame = self.bounds
        _backgroundImageView?.contentMode = .Center
        _backgroundImageView?.autoresizingMask = [.FlexibleWidth , .FlexibleHeight]
        self.addSubview(_backgroundImageView!)

        titleLabel = UILabel()
        titleLabel?.backgroundColor = UIColor.clearColor()
        titleLabel?.textColor = UIColor.darkGrayColor()
        titleLabel?.shadowColor = UIColor.whiteColor()
        titleLabel?.shadowOffset = CGSizeMake(0, 1)
        titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        titleLabel?.frame = self.bounds
        titleLabel?.textAlignment = .Center
        titleLabel?.autoresizingMask = [.FlexibleWidth , .FlexibleHeight]
        self.addSubview(titleLabel!)

        self.addObserver(self, forKeyPath: "pressed", options: .New, context: nil)
        self.addObserver(self, forKeyPath: "backgroundImage", options: .New, context: nil)
        self.addObserver(self, forKeyPath: "backgroundImagePressed", options: .New, context: nil)

        pressed = false
    }

    func setTitleEdgeInsets(_titleEdgeInsets:UIEdgeInsets)
    {
        titleEdgeInsets = _titleEdgeInsets
        self.setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        _backgroundImageView?.frame = self.bounds
        titleLabel?.frame = self.bounds

//        var frame:CGRect = (titleLabel?.frame)!
//        frame.origin.x += (titleEdgeInsets?.left)!
//        frame.origin.y += (titleEdgeInsets?.top)!
//        frame.size.width -= (titleEdgeInsets?.right)!
//        frame.size.height -= (titleEdgeInsets?.bottom)!
//        titleLabel?.frame = frame
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath!.isEqual("pressed")||keyPath!.isEqual("backgroundImage")||keyPath!.isEqual("backgroundImagePressed") {
            if (pressed == true) {
                _backgroundImageView?.image = backgroundImagePressed
            }
            else
            {
                _backgroundImageView?.image = backgroundImage
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pressed = true
        if (delegate != nil) {
            delegate?.buttonPressed(self)
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point:CGPoint = touches.first!.locationInView(self)
        let width:CGFloat = self.frame.size.width
        let height:CGFloat = self.frame.size.height

        if pressed == false {
            pressed = true
            if (delegate != nil) {
                delegate?.buttonPressed(self)
            }
        }

        if point.x < 0 || point.x > width || point.y < 0 || point.y > height
        {
            if pressed == true {
                pressed = false
                if (delegate != nil) {
                    delegate?.buttonPressed(self)
                }
            }
        }
        else
        {
            pressed = true
            if (delegate != nil) {
                delegate?.buttonPressed(self)
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        pressed = false
        if (delegate != nil) {
            delegate?.buttonReleased(self)
        }
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        pressed = false
        if (delegate != nil) {
            delegate?.buttonReleased(self)
        }
    }
}
