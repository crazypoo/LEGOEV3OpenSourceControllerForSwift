//
//  EV3Sensor.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

class EV3Sensor: NSObject {
    var _type:EV3SensorType?
    var typeString:NSString?
    var image:UIImage?
    var mode:Int?
    var data:CShort?

    override init() {
        super.init()
        _type = EV3SensorType.Unknown
        typeString = "Unknown"
        mode = 0
        data = 0
    }

    func setType(type:EV3SensorType)
    {
        if _type != type {
            _type = type
            refreshTypeStringWithType(type)
        }
    }

    func refreshTypeStringWithType(type:EV3SensorType)
    {
        switch type {
        case .LargeMotor:
            typeString = "Large Motor"
            image = UIImage.init(named: "LargeMotor")
            break
        case .MediumMotor:
            typeString = "Medium Motor"
            image = UIImage.init(named: "MediumMotor")
            break
        case .TouchSensor:
            typeString = "Touch Sensor"
            image = UIImage.init(named: "TouchSensor")
            break
        case .ColorSensor:
            typeString = "Color Sensor"
            image = UIImage.init(named: "ColorSensor")
            break
        case .UltrasonicSensor:
            typeString = "Ultrasonic Sensor"
            image = UIImage.init(named: "UltrasonicSensor")
            break
        case .GyroscopeSensor:
            typeString = "Gyroscope Sensor"
            image = UIImage.init(named: "GyroSensor")
            break
        case .InfraredSensor:
            typeString = "Infrared Sensor"
            image = UIImage.init(named: "InfraredSensor")
            break
        case .Initializing: 
            typeString = "Init"
            image = UIImage.init(named: "Init")
            break
        case .Empty: 
            typeString = "Empty"
            image = UIImage.init(named: "Empty")
            break
        case .WrongPort: 
            self.typeString = "WrongPort";
        case .Unknown:
            typeString = "Unknown"
            image = UIImage.init(named: "Unknown")
            break
        }
    }
}
