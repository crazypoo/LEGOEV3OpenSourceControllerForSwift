//
//  PDPad.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

enum PDPadDirection : UInt {
    case UpLeft = 1
    case Up
    case UpRight
    case Left
    case None
    case Right
    case DownLeft
    case Down
    case DownRight
}

protocol PDPadDelegate {
    func dPad(dpad:PDPad,direction:PDPadDirection)
    func dPadDidReleaseDirection(dPad:PDPad)
}

class PDPad: UIView {

    var delegate:PDPadDelegate?
    var _currentDirection:PDPadDirection?
    var _dPadImageView:UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInt()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInt()
    {
        _dPadImageView = UIImageView.init(image: UIImage.init(named: "dPad-None"))
        _dPadImageView?.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)
        self.addSubview(_dPadImageView!)

        _currentDirection = PDPadDirection.None
    }

    func currentDirection() ->PDPadDirection
    {
        return _currentDirection!
    }

    func directionForPoint(point:CGPoint) ->PDPadDirection
    {
        let x:CGFloat = point.x
        let y:CGFloat = point.y

        if x < 0 || x > self.bounds.size.width || y < 0 || y > self.bounds.size.height
        {
            return PDPadDirection.None
        }

        let column:NSInteger = Int(x) / (Int((self.bounds.size.width))/3)
        let row:NSInteger = Int(y) / (Int((self.bounds.size.height))/3)

        let dUint = row * 3 + column + 1
        if dUint == 1 {
           return PDPadDirection.UpLeft
        }
        else if dUint == 2
        {
            return PDPadDirection.Up
        }
        else if dUint == 3
        {
            return PDPadDirection.UpRight
        }
        else if dUint == 4
        {
            return PDPadDirection.Left
        }
        else if dUint == 5
        {
            return PDPadDirection.None
        }
        else if dUint == 6
        {
            return PDPadDirection.Right
        }
        else if dUint == 7
        {
            return PDPadDirection.DownLeft
        }
        else if dUint == 8
        {
            return PDPadDirection.Down
        }
        else if dUint == 9
        {
            return PDPadDirection.DownRight
        }
        return PDPadDirection.None
    }

    func imageForDirection(direction:PDPadDirection)->UIImage
    {
        var image = UIImage()
        switch direction {
        case .UpLeft:
            image = UIImage.init(named: "dPad-UpLeft")!
            break
        case .Up:
            image = UIImage.init(named: "dPad-Up")!
            break
        case .UpRight:
            image = UIImage.init(named: "dPad-UpRight")!
            break
        case .Left:
            image = UIImage.init(named: "dPad-Left")!
            break
        case .None:
            image = UIImage.init(named: "dPad-None")!
            break
        case .Right:
            image = UIImage.init(named: "dPad-Right")!
            break
        case .DownLeft:
            image = UIImage.init(named: "dPad-DownLeft")!
            break
        case .Down:
            image = UIImage.init(named: "dPad-Down")!
            break
        case .DownRight:
            image = UIImage.init(named: "dPad-DownRight")!
            break
        }
        return image
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point:CGPoint = touches.first!.locationInView(self)
        let direction = directionForPoint(point)
        if direction != _currentDirection
        {
            _currentDirection = direction
            _dPadImageView?.image = imageForDirection(_currentDirection!)
            if (delegate != nil) {
                delegate?.dPad(self, direction: _currentDirection!)
            }
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point:CGPoint = touches.first!.locationInView(self)
        let direction = directionForPoint(point)
        if direction != _currentDirection
        {
            _currentDirection = direction
            _dPadImageView?.image = imageForDirection(_currentDirection!)
            if (delegate != nil) {
                delegate?.dPad(self, direction: _currentDirection!)
            }
        }
    }

    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        _currentDirection = PDPadDirection.None
        _dPadImageView?.image = imageForDirection(_currentDirection!)
        if (delegate != nil) {
            delegate?.dPadDidReleaseDirection(self)
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _currentDirection = PDPadDirection.None
        _dPadImageView?.image = imageForDirection(_currentDirection!)
        if (delegate != nil) {
            delegate?.dPadDidReleaseDirection(self)
        }
    }
}
