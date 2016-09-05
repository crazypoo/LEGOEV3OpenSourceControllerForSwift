//
//  PControlRobotViewController.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit
import GameKit
import AVFoundation
import QuartzCore
import MultipeerConnectivity

class PControlRobotViewController: UIViewController,PDPadDelegate,PButtonDelegate {

    var dPad:PDPad?
    var aButton:PButton?
    var bButton:PButton?
    var devicData:EV3Device?

    func initDeviceData(data:EV3Device)
    {
        devicData = data
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dPad = PDPad.init(frame: CGRectMake(20, self.view.frame.size.height - 170, 150, 150))
        aButton = PButton.init(frame: CGRectMake(200, self.view.frame.size.height - 80, 60, 60))
        bButton = PButton.init(frame: CGRectMake(240, self.view.frame.size.height - 144, 60, 60))

        dPad?.delegate = self;
        aButton?.delegate = self
        bButton?.delegate = self

        self.view.addSubview(dPad!)

        aButton?.titleLabel?.text = "A"
        aButton?.backgroundImage = UIImage.init(named: "button")
        aButton?.backgroundImagePressed = UIImage.init(named: "button-pressed")
        self.view.addSubview(aButton!)

        bButton?.titleLabel?.text = "B"
        bButton?.backgroundImage = UIImage.init(named: "button")
        bButton?.backgroundImagePressed = UIImage.init(named: "button-pressed")
        self.view.addSubview(bButton!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func dPad(dpad: PDPad, direction: PDPadDirection) {
        if (stringForDirection(direction).isEqualToString("Up")) {
            NSLog("我按了上按钮")
            devicData?.turnMotorAtPort(EV3OutputPortB, power:-100)
            devicData?.turnMotorAtPort(EV3OutputPortC, power:-100)
        }
        else if (stringForDirection(direction).isEqualToString("Down"))
        {
            NSLog("下按钮");
            devicData?.turnMotorAtPort(EV3OutputPortB, power:100)
            devicData?.turnMotorAtPort(EV3OutputPortC, power:100)
        }
        else if (stringForDirection(direction).isEqualToString("Left"))
        {
            NSLog("左按钮");
            devicData?.turnMotorAtPort(EV3OutputPortA, power:-100)
        }
        else if (stringForDirection(direction).isEqualToString("Right"))
        {
            NSLog("右按钮");
            devicData?.turnMotorAtPort(EV3OutputPortA, power:100)
        }
        else if (stringForDirection(direction).isEqualToString("Up Left"))
        {
            NSLog("上左按钮");
            devicData?.turnMotorAtPort(EV3OutputPortA, power:-100)
            devicData?.turnMotorAtPort(EV3OutputPortB, power:-100)
            devicData?.turnMotorAtPort(EV3OutputPortC, power:-100)
        }
        else if (stringForDirection(direction).isEqualToString("Up Right"))
        {
            NSLog("上右按钮");
            devicData?.turnMotorAtPort(EV3OutputPortA, power:100)
            devicData?.turnMotorAtPort(EV3OutputPortB, power:-100)
            devicData?.turnMotorAtPort(EV3OutputPortC, power:-100)

        }
        else if (stringForDirection(direction).isEqualToString("Down Left"))
        {
            NSLog("下左按钮");
            devicData?.turnMotorAtPort(EV3OutputPortA, power:-100)
            devicData?.turnMotorAtPort(EV3OutputPortB, power:100)
            devicData?.turnMotorAtPort(EV3OutputPortC, power:100)

        }
        else if (stringForDirection(direction).isEqualToString("Down Right"))
        {
            NSLog("下右按钮");
            devicData?.turnMotorAtPort(EV3OutputPortA, power:100)
            devicData?.turnMotorAtPort(EV3OutputPortB, power:100)
            devicData?.turnMotorAtPort(EV3OutputPortC, power:100)
        }
    }

    func dPadDidReleaseDirection(dPad: PDPad) {
        devicData?.turnMotorAtPort(EV3OutputPortA, power:0)
        devicData?.turnMotorAtPort(EV3OutputPortB, power:0)
        devicData?.turnMotorAtPort(EV3OutputPortC, power:0)

    }

    func buttonPressed(button: PButton) {
        if (button.isEqual(aButton)) {
            NSLog("AAAAA")
        }
        else if (button.isEqual(bButton))
        {
            NSLog("BBBBB")
            devicData?.stopMotorAtPort(EV3OutputAll)
        }
    }

    func buttonReleased(button: PButton) {
        if (button.isEqual(aButton)) {
            NSLog("AAAAA")
        }
        else if (button.isEqual(bButton))
        {
            NSLog("BBBBB")
            devicData?.turnMotorAtPort(EV3OutputPortA, power:0)
            devicData?.turnMotorAtPort(EV3OutputPortB, power:0)
            devicData?.turnMotorAtPort(EV3OutputPortC, power:0)
        }
    }

    func stringForDirection(direction:PDPadDirection)->NSString
    {
        var string:NSString? = nil
        switch direction {
        case .UpLeft:
            string = "Up Left";break
        case .Up:
            string = "Up";break
        case .UpRight:
            string = "Up Right";break
        case .Left:
            string = "Left";break
        case .None:
            string = "None";break
        case .Right:
            string = "Right";break
        case .DownLeft:
            string = "Down Left";break
        case .Down:
            string = "Down Left";break
        case .DownRight:
            string = "Down Right";break
        }
        return string!
    }
}
