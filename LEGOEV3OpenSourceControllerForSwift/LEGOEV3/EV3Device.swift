//
//  EV3Device.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

class EV3Device: NSObject {
    var _tcpSocket:GCDAsyncSocket?
    var _serialNumber:NSString?
    var _address:NSString?
    var _tag:Int?
    var _isConnected:Bool?
    var _isScan:Bool?
    var sensorPortA:EV3Sensor?
    var sensorPortB:EV3Sensor?
    var sensorPortC:EV3Sensor?
    var sensorPortD:EV3Sensor?
    var sensorPort1:EV3Sensor?
    var sensorPort2:EV3Sensor?
    var sensorPort3:EV3Sensor?
    var sensorPort4:EV3Sensor?

    func initWithSerialNumber(serialNumber:NSString,address:NSString,tag:Int,isConnected:Bool)
    {
        _serialNumber = serialNumber
        _address = address
        _tag = tag
        _isConnected = isConnected
        sensorPort1 = EV3Sensor()
        sensorPort2 = EV3Sensor()
        sensorPort3 = EV3Sensor()
        sensorPort4 = EV3Sensor()
        sensorPortA = EV3Sensor()
        sensorPortB = EV3Sensor()
        sensorPortC = EV3Sensor()
        sensorPortD = EV3Sensor()
        _isScan = false
    }

    func handleReceivedData(data:NSData,tag:Int)
    {
        switch tag {
        case 1:
            let httpResponse = NSString.init(data: data , encoding: NSUTF8StringEncoding)
            let response:NSString = (httpResponse?.substringToIndex(12))!
            if response.isEqualToString("Accept:EV340") {
                _isConnected = true
                NSLog("ev3 connected")
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.scanPort()
                    NSNotificationCenter.defaultCenter().postNotificationName("EV3DeviceConnectedNotification", object: self)
                    });
            }
            break
        case 14:
            if _isScan == true {
                updatePorts()
            }
            let index:Int = 5
            var byteArray:[UInt8] = [UInt8]()
            for i in 0..<data.length {
                var temp:UInt8 = 0
                data.getBytes(&temp, range: NSRange(location: i,length:1 ))
                byteArray.append(temp)
            }
            
            if UInt8(byteArray[index + 1]) == 0x07 {
                sensorPort1!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x08
            {
                sensorPort1!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x10
            {
                sensorPort1!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1d
            {
                sensorPort1!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1e
            {
                sensorPort1!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x20
            {
                sensorPort1!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x21
            {
                sensorPort1!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x7d
            {
                sensorPort1!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[index + 1]) == 0x7e
            {
                sensorPort1!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[index + 1]) == 0x7f
            {
                sensorPort1!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[index + 1]) == 0xff
            {
                sensorPort1!._type! = EV3SensorType.Unknown
            }
            sensorPort1?.mode = Int(byteArray[index + 1])
            sensorPort1?.data = CShort(byteArray[index + 1]) | CShort((byteArray[index + 1] << 8))
            
            if UInt8(byteArray[index + 1]) == 0x07 {
                sensorPort2!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x08
            {
                sensorPort2!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x10
            {
                sensorPort2!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1d
            {
                sensorPort2!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1e
            {
                sensorPort2!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x20
            {
                sensorPort2!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x21
            {
                sensorPort2!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x7d
            {
                sensorPort2!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[index + 1]) == 0x7e
            {
                sensorPort2!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[index + 1]) == 0x7f
            {
                sensorPort2!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[index + 1]) == 0xff
            {
                sensorPort2!._type! = EV3SensorType.Unknown
            }
            sensorPort2?.mode = Int(byteArray[index + 1])
            sensorPort2?.data = CShort(byteArray[index + 1]) | CShort((byteArray[index + 1] << 8))

            if UInt8(byteArray[index + 1]) == 0x07 {
                sensorPort3!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x08
            {
                sensorPort3!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x10
            {
                sensorPort3!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1d
            {
                sensorPort3!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1e
            {
                sensorPort3!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x20
            {
                sensorPort3!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x21
            {
                sensorPort3!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x7d
            {
                sensorPort3!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[index + 1]) == 0x7e
            {
                sensorPort3!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[index + 1]) == 0x7f
            {
                sensorPort3!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[index + 1]) == 0xff
            {
                sensorPort3!._type! = EV3SensorType.Unknown
            }
            sensorPort3?.mode = Int(byteArray[index + 1])
            sensorPort3?.data = CShort(byteArray[index + 1]) | CShort((byteArray[index + 1] << 8))

            if UInt8(byteArray[index + 1]) == 0x07 {
                sensorPort4!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x08
            {
                sensorPort4!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x10
            {
                sensorPort4!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1d
            {
                sensorPort4!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1e
            {
                sensorPort4!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x20
            {
                sensorPort4!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x21
            {
                sensorPort4!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x7d
            {
                sensorPort4!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[index + 1]) == 0x7e
            {
                sensorPort4!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[index + 1]) == 0x7f
            {
                sensorPort4!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[index + 1]) == 0xff
            {
                sensorPort4!._type! = EV3SensorType.Unknown
            }
            sensorPort4?.mode = Int(byteArray[index + 1])
            sensorPort4?.data = CShort(byteArray[index + 1]) | CShort((byteArray[index + 1] << 8))

            
            if UInt8(byteArray[index + 1]) == 0x07 {
                sensorPortA!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x08
            {
                sensorPortA!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x10
            {
                sensorPortA!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1d
            {
                sensorPortA!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1e
            {
                sensorPortA!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x20
            {
                sensorPortA!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x21
            {
                sensorPortA!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x7d
            {
                sensorPortA!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[index + 1]) == 0x7e
            {
                sensorPortA!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[index + 1]) == 0x7f
            {
                sensorPortA!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[index + 1]) == 0xff
            {
                sensorPortA!._type! = EV3SensorType.Unknown
            }
            sensorPortA?.mode = Int(byteArray[index + 1])
            sensorPortA?.data = CShort(byteArray[index + 1]) | CShort((byteArray[index + 1] << 8))

            
            if UInt8(byteArray[index + 1]) == 0x07 {
                sensorPortB!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x08
            {
                sensorPortB!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x10
            {
                sensorPortB!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1d
            {
                sensorPortB!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1e
            {
                sensorPortB!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x20
            {
                sensorPortB!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x21
            {
                sensorPortB!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x7d
            {
                sensorPortB!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[index + 1]) == 0x7e
            {
                sensorPortB!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[index + 1]) == 0x7f
            {
                sensorPortB!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[index + 1]) == 0xff
            {
                sensorPortB!._type! = EV3SensorType.Unknown
            }
            sensorPortB?.mode = Int(byteArray[index + 1])
            sensorPortB?.data = CShort(byteArray[index + 1]) | CShort((byteArray[index + 1] << 8))

            
            if UInt8(byteArray[index + 1]) == 0x07 {
                sensorPortC!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x08
            {
                sensorPortC!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x10
            {
                sensorPortC!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1d
            {
                sensorPortC!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1e
            {
                sensorPortC!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x20
            {
                sensorPortC!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x21
            {
                sensorPortC!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x7d
            {
                sensorPortC!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[index + 1]) == 0x7e
            {
                sensorPortC!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[index + 1]) == 0x7f
            {
                sensorPortC!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[index + 1]) == 0xff
            {
                sensorPortC!._type! = EV3SensorType.Unknown
            }
            sensorPortC?.mode = Int(byteArray[index + 1])
            sensorPortC?.data = CShort(byteArray[index + 1]) | CShort((byteArray[index + 1] << 8))

            
            if UInt8(byteArray[index + 1]) == 0x07 {
                sensorPortD!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x08
            {
                sensorPortD!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[index + 1]) == 0x10
            {
                sensorPortD!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1d
            {
                sensorPortD!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x1e
            {
                sensorPortD!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x20
            {
                sensorPortD!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x21
            {
                sensorPortD!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[index + 1]) == 0x7d
            {
                sensorPortD!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[index + 1]) == 0x7e
            {
                sensorPortD!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[index + 1]) == 0x7f
            {
                sensorPortD!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[index + 1]) == 0xff
            {
                sensorPortD!._type! = EV3SensorType.Unknown
            }
            sensorPortD?.mode = Int(byteArray[index + 1])
            sensorPortD?.data = CShort(byteArray[index + 1]) | CShort((byteArray[index + 1] << 8))


            break
        case 15:
            var byteArray:[UInt8] = [UInt8]()
            for i in 0..<data.length
            {
                var temp:UInt8 = 0
                data.getBytes(&temp, range: NSRange(location: i,length:1 ))
                byteArray.append(temp)
            }

            if UInt8(byteArray[5]) == 0x07 {
                sensorPortA!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[5]) == 0x08
            {
                sensorPortA!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[5]) == 0x10
            {
                sensorPortA!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[5]) == 0x1d
            {
                sensorPortA!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[5]) == 0x1e
            {
                sensorPortA!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[5]) == 0x20
            {
                sensorPortA!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[5]) == 0x21
            {
                sensorPortA!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[5]) == 0x7d
            {
                sensorPortA!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[5]) == 0x7e
            {
                sensorPortA!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[5]) == 0x7f
            {
                sensorPortA!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[5]) == 0xff
            {
                sensorPortA!._type! = EV3SensorType.Unknown
            }
            sensorPortA!.mode = Int(byteArray[6])

            if UInt8(byteArray[7]) == 0x07 {
                sensorPortB!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[7]) == 0x08
            {
                sensorPortB!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[7]) == 0x10
            {
                sensorPortB!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[7]) == 0x1d
            {
                sensorPortB!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[7]) == 0x1e
            {
                sensorPortB!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[7]) == 0x20
            {
                sensorPortB!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[7]) == 0x21
            {
                sensorPortB!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[7]) == 0x7d
            {
                sensorPortB!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[7]) == 0x7e
            {
                sensorPortB!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[7]) == 0x7f
            {
                sensorPortB!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[7]) == 0xff
            {
                sensorPortB!._type! = EV3SensorType.Unknown
            }
            sensorPortB!.mode = Int(byteArray[8])
            
            if UInt8(byteArray[9]) == 0x07 {
                sensorPortC!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[9]) == 0x08
            {
                sensorPortC!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[9]) == 0x10
            {
                sensorPortC!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[9]) == 0x1d
            {
                sensorPortC!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[9]) == 0x1e
            {
                sensorPortC!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[9]) == 0x20
            {
                sensorPortC!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[9]) == 0x21
            {
                sensorPortC!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[9]) == 0x7d
            {
                sensorPortC!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[9]) == 0x7e
            {
                sensorPortC!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[9]) == 0x7f
            {
                sensorPortC!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[9]) == 0xff
            {
                sensorPortC!._type! = EV3SensorType.Unknown
            }
            sensorPortC!.mode = Int(byteArray[10])
            
            if UInt8(byteArray[11]) == 0x07 {
                sensorPortD!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[11]) == 0x08
            {
                sensorPortD!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[11]) == 0x10
            {
                sensorPortD!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[11]) == 0x1d
            {
                sensorPortD!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[11]) == 0x1e
            {
                sensorPortD!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[11]) == 0x20
            {
                sensorPortD!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[11]) == 0x21
            {
                sensorPortD!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[11]) == 0x7d
            {
                sensorPortD!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[11]) == 0x7e
            {
                sensorPortD!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[11]) == 0x7f
            {
                sensorPortD!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[1]) == 0xff
            {
                sensorPortD!._type! = EV3SensorType.Unknown
            }
            sensorPortD!.mode = Int(byteArray[12])
            
            if UInt8(byteArray[13]) == 0x07 {
                sensorPort1!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[13]) == 0x08
            {
                sensorPort1!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[13]) == 0x10
            {
                sensorPort1!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[13]) == 0x1d
            {
                sensorPort1!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[13]) == 0x1e
            {
                sensorPort1!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[13]) == 0x20
            {
                sensorPort1!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[13]) == 0x21
            {
                sensorPort1!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[13]) == 0x7d
            {
                sensorPort1!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[13]) == 0x7e
            {
                sensorPort1!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[13]) == 0x7f
            {
                sensorPort1!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[13]) == 0xff
            {
                sensorPort1!._type! = EV3SensorType.Unknown
            }
            sensorPort1!.mode = Int(byteArray[14])

            if UInt8(byteArray[15]) == 0x07 {
                sensorPort2!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[15]) == 0x08
            {
                sensorPort2!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[15]) == 0x10
            {
                sensorPort2!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[15]) == 0x1d
            {
                sensorPort2!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[15]) == 0x1e
            {
                sensorPort2!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[15]) == 0x20
            {
                sensorPort2!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[15]) == 0x21
            {
                sensorPort2!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[15]) == 0x7d
            {
                sensorPort2!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[15]) == 0x7e
            {
                sensorPort2!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[15]) == 0x7f
            {
                sensorPort2!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[15]) == 0xff
            {
                sensorPort2!._type! = EV3SensorType.Unknown
            }
            sensorPort2!.mode = Int(byteArray[16])

            
            if UInt8(byteArray[17]) == 0x07 {
                sensorPort3!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[17]) == 0x08
            {
                sensorPort3!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[17]) == 0x10
            {
                sensorPort3!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[17]) == 0x1d
            {
                sensorPort3!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[17]) == 0x1e
            {
                sensorPort3!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[17]) == 0x20
            {
                sensorPort3!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[17]) == 0x21
            {
                sensorPort3!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[17]) == 0x7d
            {
                sensorPort3!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[17]) == 0x7e
            {
                sensorPort3!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[17]) == 0x7f
            {
                sensorPort3!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[17]) == 0xff
            {
                sensorPort3!._type! = EV3SensorType.Unknown
            }
            sensorPort3!.mode = Int(byteArray[18])

            
            if UInt8(byteArray[19]) == 0x07 {
                sensorPort4!._type! = EV3SensorType.LargeMotor
            }
            else if UInt8(byteArray[19]) == 0x08
            {
                sensorPort4!._type! = EV3SensorType.MediumMotor
            }
            else if UInt8(byteArray[19]) == 0x10
            {
                sensorPort4!._type! = EV3SensorType.TouchSensor
            }
            else if UInt8(byteArray[19]) == 0x1d
            {
                sensorPort4!._type! = EV3SensorType.ColorSensor
            }
            else if UInt8(byteArray[19]) == 0x1e
            {
                sensorPort4!._type! = EV3SensorType.UltrasonicSensor
            }
            else if UInt8(byteArray[19]) == 0x20
            {
                sensorPort4!._type! = EV3SensorType.GyroscopeSensor
            }
            else if UInt8(byteArray[19]) == 0x21
            {
                sensorPort4!._type! = EV3SensorType.InfraredSensor
            }
            else if UInt8(byteArray[19]) == 0x7d
            {
                sensorPort4!._type! = EV3SensorType.Initializing
            }
            else if UInt8(byteArray[19]) == 0x7e
            {
                sensorPort4!._type! = EV3SensorType.Empty
            }
            else if UInt8(byteArray[19]) == 0x7f
            {
                sensorPort4!._type! = EV3SensorType.WrongPort
            }
            else if UInt8(byteArray[19]) == 0xff
            {
                sensorPort4!._type! = EV3SensorType.Unknown
            }
            sensorPort4!.mode = Int(byteArray[20])

            break
        case 16:
            var byteArray:[UInt8] = [UInt8]()
            for i in 0..<data.length {
                var temp:UInt8 = 0
                data.getBytes(&temp, range: NSRange(location: i,length:1 ))
                byteArray.append(temp)
            }
            sensorPortA?.data = CShort(byteArray[5]) | CShort((byteArray[6] << 8))
            sensorPortB?.data = CShort(byteArray[5]) | CShort((byteArray[6] << 8))
            sensorPortC?.data = CShort(byteArray[5]) | CShort((byteArray[6] << 8))
            sensorPortD?.data = CShort(byteArray[5]) | CShort((byteArray[6] << 8))
            sensorPort1?.data = CShort(byteArray[5]) | CShort((byteArray[6] << 8))
            sensorPort2?.data = CShort(byteArray[5]) | CShort((byteArray[6] << 8))
            sensorPort3?.data = CShort(byteArray[5]) | CShort((byteArray[6] << 8))
            sensorPort4?.data = CShort(byteArray[5]) | CShort((byteArray[6] << 8))

            break
        case 12:
            break
        case 13:
            break
        default:
            break
        }
    }
    
    func clearCommands()
    {
        let data:NSData = EV3DirectCommander.clearAllCommands()
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 17)
    }
    
    func scanPort()
    {
        _isScan = true
        clearCommands()
        updatePorts()
    }
    
    func stopScan()
    {
        _isScan = false
        clearCommands()
    }
    
    func updatePorts()
    {
        let data:NSData = EV3DirectCommander.scanPorts()
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 14)
        _tcpSocket?.readDataWithTimeout(-1, tag: 14)
    }
    
    func turnMotorAtPort(port:EV3OutputPort,power:Int)
    {
        let data:NSData = EV3DirectCommander.turnMotorAtPort(port, power: power)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
    
    func turnMotorAtPort(port:EV3OutputPort,power:Int,time:NSTimeInterval)
    {
        var data:NSData = EV3DirectCommander.turnMotorAtPort(port, power: power)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
        NSThread.sleepForTimeInterval(time)
        data = EV3DirectCommander.turnMotorAtPort(port, power: 0)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
    
    func turnMotorAtPort(port:EV3OutputPort,power:Int,degrees:UInt32)
    {
        let data:NSData = EV3DirectCommander.turnMotorAtPort(port, power: power,degrees: degrees)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
    
    func stopMotorAtPort(port:EV3OutputPort)
    {
        let data:NSData = EV3DirectCommander.stopMotorAtPort(port)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
    
    func playToneAtVolume(volume:Int,frequency:UInt16,duration:UInt16)
    {
        let data:NSData = EV3DirectCommander.playToneWithVolume(volume, frequency: frequency, duration: duration)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
    
    func playSoundAtVolume(volume:Int,filename:NSString,repeats:Bool)
    {
        let data:NSData = EV3DirectCommander.playSoundWithVolume(volume, filename: filename, repeats: repeats)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
    
    func playSoundBrake()
    {
        let data:NSData = EV3DirectCommander.soundBrake()
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
    
    func drawImageAtColor(color:EV3ScreenColor,x:UInt16,y:UInt16,filename:NSString)
    {
        let data:NSData = EV3DirectCommander.drawImageWithColor(color, x: x, y: y, filename: filename)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
    
    func drawText(text:NSString,color:EV3ScreenColor,x:UInt16,y:UInt16)
    {
        let data:NSData = EV3DirectCommander.drawText(text, color: color, x: x, y: y)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
    
    func drawFillWindowAtColor(color:EV3ScreenColor,y0:UInt16,y1:UInt16)
    {
        let data:NSData = EV3DirectCommander.drawFillWindowWithColor(color, y0: y0, y1: y1)
        _tcpSocket?.writeData(data, withTimeout: -1, tag: 11)
    }
}
