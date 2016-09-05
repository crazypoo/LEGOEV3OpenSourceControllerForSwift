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

    func initWithCommandType(commandType:EV3CommandType,globalSize:UInt16,localSize:Int)
    {
        buffer[0] = 0xff
        buffer[1] = 0xff
        buffer[2] = 0x00
        buffer[3] = 0x00
        switch commandType {
        case .DirectReply:
            buffer[4] = 0x00
            break
        case .DirectNoReply:
            buffer[4] = 0x80
            break
        }
        buffer[5] = UInt8(globalSize & 0xff)
        buffer[6] = UInt8(localSize << 2) | UInt8(globalSize >> 8 & 0x03)
        cursor = 7
    }

    func addOperationCode(operationCode:EV3OperationCode)
    {
        if operationCode > EV3OperationTest
        {
            buffer[cursor!] = (operationCode & 0xff00) >> 8
            cursor! + 1
        }
        buffer[cursor!] = operationCode & 0xff
        cursor! + 1
    }
}
