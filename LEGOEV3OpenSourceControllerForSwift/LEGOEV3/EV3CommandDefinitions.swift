//
//  EV3CommandDefinitions.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

//import UIKit
//
//class EV3CommandDefinitions: NSObject {
//
//}
enum EV3ParameterSize : Int {
    case Byte = 0x81
    case Int16 = 0x82
    case Int32 = 0x83
    case String = 0x84
}

enum EV3ReplyType : Int {
    case Direct = 0x82
    case System = 0x83
    case DirectError = 0x04
    case SystemError = 0x05
}

enum EV3OperationCode : Int {
    case EV3OperationUIReadGetFirmware = 0x810a
    case EV3OperationUIWriteLED = 0x821b
    case EV3OperationUIButtonPressed = 0x8309
    case EV3OperationUIDrawUpdate = 0x8400
    case EV3OperationUIDrawClean = 0x8401
    case EV3OperationUIDrawPixel = 0x8402
    case EV3OperationUIDrawLine = 0x8403
    case EV3OperationUIDrawCircle = 0x8404
    case EV3OperationUIDrawText = 0x8405
    case EV3OperationUIDrawFillRect = 0x8409
//    case EV3OperationUIDrawRect = 0x8401
    case EV3OperationUIDrawInverseRect = 0x8410
    case EV3OperationUIDrawSelectFont = 0x8411
    case EV3OperationUIDrawTopline = 0x8412
    case EV3OperationUIDrawFillWindow = 0x8413
    case EV3OperationUIDrawDotLIne = 0x8415
    case EV3OperationUIDrawFillCircle = 0x8418
    case EV3OperationUIDrawBmpFile = 0x841c
    case EV3OperationSoundBreak = 0x9400
    case EV3OperationSoundTone = 0x9401
    case EV3OperationSoundPlay = 0x9402
    case EV3OperationSoundRepeat = 0x9403
    case EV3OperationSoundService = 0x9404
    case EV3OperationInputDeviceGetTypeMode = 0x9905
    case EV3OperationInputDeviceGetDeviceName = 0x9915
    case EV3OperationInputDeviceGetModeName = 0x9916
    case EV3OperationInputDeviceReadyPct = 0x991b
    case EV3OperationInputDeviceReadyRaw = 0x991c
    case EV3OperationInputDeviceReadySI = 0x991d
    case EV3OperationInputDeviceClearAll = 0x990a
    case EV3OperationInputDeviceClearChanges = 0x991a
    case EV3OperationInputRead = 0x9a
    case EV3OperationInputReadExt = 0x9e
    case EV3OperationInputReadSI = 0x9d
    case EV3OperationOutputStop = 0xa3
    case EV3OperationOutputPower = 0xa4
    case EV3OperationOutputSpeed = 0xa5
    case EV3OperationOutputStart = 0xa6
    case EV3OperationOutputPolarity = 0xa7
    case EV3OperationOutputStepPower = 0xac
    case EV3OperationOutputTimePower = 0xad
    case EV3OperationOutputStepSpeed = 0xae
    case EV3OperationOutputTimeSpeed = 0xaf
    case EV3OperationOutputStepSync = 0xb0
    case EV3OperationOutputTimeSync = 0xb1
    case EV3OperationTest = 0xff
}

enum EV3CommandType : Int {
    case DirectReply = 0x00
    case DirectNoReply = 0x80
}

enum EV3SensorDataFormat : Int {
    case Percent = 0x10
    case Raw = 0x11
    case SI = 0x12
}

enum EV3MotorPolarity : Int {
    case Backward = -1
    case Opposite = 0
    case Forward = 1
}

enum EV3InputPort : Int {
    case _1 = 0x00
    case _2 = 0x01
    case _3 = 0x02
    case _4 = 0x03
    case A = 0x10
    case B = 0x11
    case C = 0x12
    case D = 0x13
}

enum EV3OutputPort : Int {
    case A = 0x01
    case B = 0x02
    case C = 0x04
    case D = 0x08
    case EV3OutputAll = 0x0f
}

enum EV3SensorType : Int {
    case LargeMotor = 0x07
    case MediumMotor = 0x08
    case TouchSensor = 0x10
    case ColorSensor = 0x1d
    case UltrasonicSensor = 0x1e
    case GyroscopeSensor = 0x20
    case InfraredSensor = 0x21
    case Initializing = 0x7d
    case Empty = 0x7e
    case WrongPort = 0x7f
    case Unknown = 0xff
}

enum EV3BrickButton : Int {
    case None
    case Up
    case Enter
    case Down
    case Right
    case Left
    case Back
    case Any
}

enum EV3LEDPattern : Int {
    case Black
    case Green
    case Red
    case Orange
    case GreenFlash
    case RedFlash
    case OrangeFlash
    case GreenPulse
    case RedPulse
    case OrangePulse
}

enum EV3ScreenColor : Int {
    case Background
    case Foreground
}

enum EV3FontType : Int {
    case Small
    case Medium
    case Large
}

enum EV3TouchSensorMode : Int {
    case Touch
    case Bumps
}

enum EV3MotorMode : Int {
    case Degrees
    case Rotations
}

enum EV3ColorSensorMode : Int {
    case Reflective
    case Ambient
    case Color
    case ReflectiveRaw
    case ReflectiveRGB
    case Calibration
}

enum EV3UltrasonicSensorMode : Int {
    case Centimeters
    case Inches
    case Listen
}

enum EV3GyroscopeSensorMode : Int {
    case Angle
    case Rate
    case GyroCalibration = 0x04
}

enum EV3InfraredSensorMode : Int {
    case Proximity
    case Seek
    case Remote
    case RemoteA
    case SAlt
    case InfrCalibration
}

enum EV3ColorSensorColor : Int {
    case Transparent
    case BlackColor
    case BlueColor
    case GreenColor
    case YellowColor
    case RedColor
    case WhiteColor
    case BrownColor
}