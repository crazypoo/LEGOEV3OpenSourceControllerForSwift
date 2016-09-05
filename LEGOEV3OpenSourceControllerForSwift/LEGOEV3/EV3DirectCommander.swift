//
//  EV3DirectCommander.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

class EV3DirectCommander: NSObject {

    var cursor:Int?
    var buffer:[UInt8] = [UInt8]()

    init(commandType: EV3CommandType, globalSize: UInt16, localSize: Int32) {
        super.init()
        buffer[0] = 0xff
        buffer[1] = 0xff
        buffer[2] = 0x00
        buffer[3] = 0x00
        buffer[4] = UInt8(commandType.rawValue)
        buffer[5] = UInt8(globalSize & 0xff)
        buffer[6] = UInt8((localSize << 2)) | UInt8((globalSize >> 8) & 0x03)
        cursor = 7
    }
//    func initWithCommandType(commandType:EV3CommandType,globalSize:UInt16,localSize:Int)
//    {
//        
//        buffer[0] = 0xff
//        buffer[1] = 0xff
//        buffer[2] = 0x00
//        buffer[3] = 0x00
//        switch commandType {
//        case .DirectReply:
//            buffer[4] = 0x00
//            break
//        case .DirectNoReply:
//            buffer[4] = 0x80
//            break
//        }
//        buffer[5] = UInt8(globalSize & 0xff)
//        buffer[6] = UInt8(localSize << 2) | UInt8(globalSize >> 8 & 0x03)
//        cursor = 7
//    }

    func addOperationCode(operationCode:EV3OperationCode)
    {
        let a = Int(operationCode.rawValue)
        let b = Int(EV3OperationCode.EV3OperationTest.rawValue)
        if a > b
        {
            buffer[cursor!] = UInt8((operationCode.rawValue & 0xff00) >> 8)
            cursor! + 1
        }
        buffer[cursor!] = UInt8(operationCode.rawValue & 0xff)
        cursor! + 1
    }
    
    func addParameterWithInt8(parameter:UInt8)
    {
        buffer[cursor!] = UInt8(EV3ParameterSize.Byte.rawValue)
        cursor! + 1
        buffer[cursor!] = parameter
        cursor! + 1
    }
    
    func addParameterWithInt16(parameter:UInt16)
    {
        buffer[cursor!] = UInt8(EV3ParameterSize.Int16.rawValue)
        cursor! + 1
        buffer[cursor!] = UInt8(parameter)
        cursor! + 1
        buffer[cursor!] = UInt8((parameter & 0xff00) >> 8)
        cursor! + 1
    }
    
    func addParameterWithInt32(parameter:UInt32)
    {
        buffer[cursor!] = UInt8(EV3ParameterSize.Int32.rawValue)
        cursor! + 1
        buffer[cursor!] = UInt8(parameter)
        cursor! + 1
        buffer[cursor!] = UInt8((parameter & 0xff00) >> 8);
        cursor! + 1
        buffer[cursor!] = UInt8((parameter & 0xff0000) >> 16);
        cursor! + 1
        buffer[cursor!] = UInt8((parameter & 0xff000000) >> 24);
        cursor! + 1
    }
    
    func addParameterWithString(string:NSString)
    {
        buffer[cursor!] = UInt8(EV3ParameterSize.String.rawValue)
        cursor! + 1
        let byteData:NSData = string.dataUsingEncoding(NSUTF8StringEncoding)!
        var bytes:[UInt8] = [UInt8]()
        NSLog("Bytes: ")
        for i in 0 ..< byteData.length {
            buffer[cursor!] = bytes[i];
            cursor! + 1
            NSLog("%d ",bytes[i])
        }
        buffer[cursor!] = 0x00
        cursor! + 1
    }
    
    func addRawParameterWithInt8(parameter:UInt8)
    {
        buffer[cursor!] = parameter
        cursor! + 1
    }
    
    func addGlobalIndex(index:UInt8)
    {
        buffer[cursor!] = 0xe1
        cursor! + 1
        buffer[cursor!] = index
        cursor! + 1
    }
    
    func addCommandSize()
    {
        let commandSize = cursor! - 2
        buffer[0] = UInt8(commandSize & 0xff)
        buffer[1] = UInt8((commandSize & 0xff00) >> 8)
    }
    
    func assembledCommandData()->NSData
    {
        addCommandSize()
        return NSData.init(bytes: buffer, length: cursor!)
    }
    
    func addCommandReadSensorTypeAndModeAtPort(port:EV3InputPort,index:UInt8)
    {
        addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        addParameterWithInt8(0x00)
        addParameterWithInt8(UInt8(port.rawValue))
        addGlobalIndex(index)
        addGlobalIndex(index+1)
    }
    
    func addCommandReadSensorDataAtPort(port:EV3InputPort,mode:UInt8,index:UInt8)
    {
        addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        addParameterWithInt8(0x00)
        addParameterWithInt8(UInt8(port.rawValue))
        addParameterWithInt8(0x00)
        addParameterWithInt8(mode)
        addParameterWithInt8(0x01)
        addGlobalIndex(index)
    }
    
    class func turnMotorAtPort(port:EV3OutputPort,power:Int)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationOutputPower)
        command?.addParameterWithInt8(0)
        command?.addParameterWithInt8(UInt8(port.rawValue))
        if (abs(port.rawValue)>100) {
            command?.addParameterWithInt8(100)
        }
        else
        {
            command?.addParameterWithInt8(UInt8(power))
        }
        command?.addOperationCode(EV3OperationCode.EV3OperationOutputStart)
        command?.addParameterWithInt8(0)
        command?.addParameterWithInt8(UInt8(port.rawValue))
        return (command?.assembledCommandData())!
    }
    
    class func turnMotorAtPort(port:EV3OutputPort,power:Int,degrees:UInt32)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationOutputStepPower)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(port.rawValue))
        command?.addParameterWithInt8(UInt8(power))
        command?.addParameterWithInt32(0x00)
        command?.addParameterWithInt32(degrees)
        command?.addParameterWithInt32(0x00)
        command?.addParameterWithInt8(0x01)
        return (command?.assembledCommandData())!
    }
    
    class func stopMotorAtPort(port:EV3OutputPort)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationOutputStop)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(port.rawValue))
        command?.addParameterWithInt8(0x01)
        return (command?.assembledCommandData())!
    }
    
    class func clearAllCommands()->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceClearAll)
        command?.addParameterWithInt8(0x00)
        return (command?.assembledCommandData())!
    }
    
    class func playToneWithVolume(volume:Int,frequency:UInt16,duration:UInt16)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationSoundTone)
        command?.addParameterWithInt8(UInt8(volume))
        command?.addParameterWithInt16(frequency)
        command?.addParameterWithInt16(duration)
        return (command?.assembledCommandData())!
    }
    
    class func playSoundWithVolume(volume:Int,filename:NSString,repeats:Bool)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationSoundPlay)
        command?.addParameterWithInt8(UInt8(volume))
        command?.addParameterWithString(filename)
        if repeats == true {
            command?.addOperationCode(EV3OperationCode.EV3OperationSoundRepeat)
            command?.addParameterWithInt8(UInt8(volume))
            command?.addParameterWithString(filename)
        }
        return (command?.assembledCommandData())!
    }
    
    class func soundBrake()->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationSoundBreak)
        return (command?.assembledCommandData())!
    }
    
    class func drawImageWithColor(color:EV3ScreenColor,x:UInt16,y:UInt16,filename:NSString)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawClean)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawUpdate)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawBmpFile)
        command?.addParameterWithInt8(UInt8(color.rawValue))
        command?.addParameterWithInt16(x)
        command?.addParameterWithInt16(y)
        command?.addParameterWithString(filename)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawUpdate)
        return (command?.assembledCommandData())!
    }
    
    class func drawText(text:NSString,color:EV3ScreenColor,x:UInt16,y:UInt16)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawClean)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawUpdate)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawText)
        command?.addParameterWithInt8(UInt8(color.rawValue))
        command?.addParameterWithInt16(x)
        command?.addParameterWithInt16(y)
        command?.addParameterWithString(text)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawUpdate)
        return (command?.assembledCommandData())!
    }
    
    class func updateUI()->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawUpdate)
        return (command?.assembledCommandData())!
    }
    
    class func clearUI()->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawClean)
        return (command?.assembledCommandData())!
    }
    
    class func drawFillWindowWithColor(color:EV3ScreenColor,y0:UInt16,y1:UInt16)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectNoReply, globalSize: 0, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawClean)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawUpdate)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawFillWindow)
        command?.addParameterWithInt8(UInt8(color.rawValue))
        command?.addParameterWithInt16(y0)
        command?.addParameterWithInt16(y1)
        command?.addOperationCode(EV3OperationCode.EV3OperationUIDrawUpdate)
        return (command?.assembledCommandData())!
    }
    
    class func scanPorts()->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectReply, globalSize: 32, localSize: 0)
        command?.addCommandReadSensorTypeAndModeAtPort(EV3InputPort._1, index: 0)
        command?.addCommandReadSensorDataAtPort(EV3InputPort._1, mode: 0, index: 2)
        command?.addCommandReadSensorTypeAndModeAtPort(EV3InputPort._2, index: 4)
        command?.addCommandReadSensorDataAtPort(EV3InputPort._2, mode: 0, index: 6)
        command?.addCommandReadSensorTypeAndModeAtPort(EV3InputPort._3, index: 8)
        command?.addCommandReadSensorDataAtPort(EV3InputPort._3, mode: 0, index: 10)
        command?.addCommandReadSensorTypeAndModeAtPort(EV3InputPort._4, index: 12)
        command?.addCommandReadSensorDataAtPort(EV3InputPort._4, mode: 0, index: 14)
        command?.addCommandReadSensorTypeAndModeAtPort(EV3InputPort.A, index: 16)
        command?.addCommandReadSensorDataAtPort(EV3InputPort.A, mode: 0, index: 18)
        command?.addCommandReadSensorTypeAndModeAtPort(EV3InputPort.B, index: 20)
        command?.addCommandReadSensorDataAtPort(EV3InputPort.B, mode: 0, index: 22)
        command?.addCommandReadSensorTypeAndModeAtPort(EV3InputPort.C, index: 24)
        command?.addCommandReadSensorDataAtPort(EV3InputPort.C, mode: 0, index: 26)
        command?.addCommandReadSensorTypeAndModeAtPort(EV3InputPort.D, index: 28)
        command?.addCommandReadSensorDataAtPort(EV3InputPort.D, mode: 0, index: 30)
        return (command?.assembledCommandData())!
    }
    
    class func scanSensorTypeAndMode()->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectReply, globalSize: 16, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort.A.rawValue))
        command?.addGlobalIndex(0)
        command?.addGlobalIndex(1)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort.B.rawValue))
        command?.addGlobalIndex(2)
        command?.addGlobalIndex(3)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort.C.rawValue))
        command?.addGlobalIndex(4)
        command?.addGlobalIndex(5)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort.D.rawValue))
        command?.addGlobalIndex(6)
        command?.addGlobalIndex(7)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort._1.rawValue))
        command?.addGlobalIndex(8)
        command?.addGlobalIndex(9)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort._2.rawValue))
        command?.addGlobalIndex(10)
        command?.addGlobalIndex(11)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort._3.rawValue))
        command?.addGlobalIndex(12)
        command?.addGlobalIndex(13)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort._4.rawValue))
        command?.addGlobalIndex(14)
        command?.addGlobalIndex(15)
        return (command?.assembledCommandData())!
    }
    
    class func scanSensorData()->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectReply, globalSize: 16, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort.A.rawValue))
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x01)
        command?.addGlobalIndex(0)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort.B.rawValue))
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x01)
        command?.addGlobalIndex(2)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort.C.rawValue))
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x01)
        command?.addGlobalIndex(4)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort.D.rawValue))
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x01)
        command?.addGlobalIndex(6)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort._1.rawValue))
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x01)
        command?.addGlobalIndex(8)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort._2.rawValue))
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x01)
        command?.addGlobalIndex(10)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort._3.rawValue))
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x01)
        command?.addGlobalIndex(12)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(EV3InputPort._4.rawValue))
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(0x01)
        command?.addParameterWithInt8(0x01)
        command?.addGlobalIndex(14)
        return (command?.assembledCommandData())!
    }
    
    class func readSensorTypeAndModeAtPort(port:EV3InputPort)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectReply, globalSize: 2, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceGetTypeMode)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(port.rawValue))
        command?.addGlobalIndex(0)
        command?.addGlobalIndex(1)
        return (command?.assembledCommandData())!
    }
    
    class func readSensorDataAtPort(port:EV3InputPort,mode:Int)->NSData
    {
        let command:EV3DirectCommander? = EV3DirectCommander.init(commandType: EV3CommandType.DirectReply, globalSize: 2, localSize: 0)
        command?.addOperationCode(EV3OperationCode.EV3OperationInputDeviceReadyRaw)
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(port.rawValue))
        command?.addParameterWithInt8(0x00)
        command?.addParameterWithInt8(UInt8(mode))
        command?.addParameterWithInt8(0x01)
        command?.addGlobalIndex(0)
        return (command?.assembledCommandData())!
    }
    
}
