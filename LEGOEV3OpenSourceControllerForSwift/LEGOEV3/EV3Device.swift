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
            let httpResponse = NSString.init(data: data, encoding: NSUTF8StringEncoding)
            let response:NSString = (httpResponse?.substringToIndex(12))!
            if response.isEqualToString("Accept:EV340") {
                _isConnected = true
                NSLog("ev3 connected")
                dispatch_async(dispatch_get_main_queue(), {
                    /**
                     *  scanPorts
                     */                    NSNotificationCenter.defaultCenter().postNotificationName("EV3DeviceConnectedNotification", object: self)
                    });
            }
            break
        case 14:
            if _isScan == true {
                /**
                 *  updatePorts
                 */
                var bytes:[UInt8] = [UInt8]()
                var index:Int = 5
                var b:Int = index + 1
            }
            break
        default:
            break
        }
    }
}
