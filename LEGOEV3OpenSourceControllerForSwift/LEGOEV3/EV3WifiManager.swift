//
//  EV3WifiManager.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

protocol EV3WifiManagerDelegate {
    func updateView()
}

public class EV3WifiManager: NSObject {

    var udpSocket:GCDAsyncUdpSocket?
    var devices:NSMutableDictionary?
    var delegate:EV3WifiManagerDelegate?
    var timer:NSTimer?

    static var _sharedInstance = EV3WifiManager()


    static func sharedInstance()->EV3WifiManager
    {
        var onceToken :dispatch_once_t = 0
        dispatch_once(&onceToken,{
            _sharedInstance = EV3WifiManager()
        })
        return _sharedInstance
    }

    override init() {
        super.init()
        let udpSocketQueue:dispatch_queue_t = dispatch_queue_create("com.manmanlai.updSocketQueue", DISPATCH_QUEUE_CONCURRENT)
        udpSocket = GCDAsyncUdpSocket.init(delegate: self, delegateQueue: udpSocketQueue)
        devices = NSMutableDictionary()
    }

    func startUdpSocket()
    {
        do
        {
            try udpSocket?.bindToPort(3015)
            return
        }
        catch
        {
            print(error)
        }

        do
        {
            try udpSocket?.beginReceiving()
            return
        }
        catch
        {
            print(error)
        }
    }

    func stopUdpSocket()
    {
        udpSocket?.close()
    }

    func udpSocket(sock:GCDAsyncUdpSocket,data:NSData,address:NSData,filterContext:AnyObject)
    {
        let msg:NSString? = NSString.init(data: data, encoding: NSUTF8StringEncoding)
        if (msg != nil)
        {
            let serialNumber:NSString? = msg?.substringWithRange(NSMakeRange(14, 12))
            let host:NSString? = GCDAsyncUdpSocket.hostFromAddress(address)
            let device = devices?.objectForKey(host!)

            if host?.length < 20 && device == nil {
                let aDevice = EV3Device()
                aDevice.initWithSerialNumber(String(serialNumber), address: String(host), tag: Int(devices!.count), isConnected:false)
                let tcpSocketQueue:dispatch_queue_t = dispatch_queue_create("com.manmanlai.tcpSocketQueue", DISPATCH_QUEUE_CONCURRENT)
                let tcpSocket = GCDAsyncSocket.init(delegate: self, delegateQueue: tcpSocketQueue)
                aDevice._tcpSocket = tcpSocket
                devices?.setObject(aDevice, forKey: aDevice._address!)
                if (delegate != nil) {
                    delegate?.updateView()
                }
            }
        }
        else
        {
            NSLog("Error converting received data into UTF-8 String")
        }
        udpSocket?.sendData(data, toAddress: address, withTimeout: -1, tag: 0)
    }

    func connectTCPSocketWithDevice(device:EV3Device)
    {
        let tcpSocket:GCDAsyncSocket = device._tcpSocket!
        do
        {
            try tcpSocket.connectToHost(device._address! as String, onPort: 5555)

            let unlockMsg = "GET /target?sn=\(device._serialNumber) VMTP1.0 Protocol: EV3"
            let unlockData = unlockMsg.dataUsingEncoding(NSUTF8StringEncoding)
            tcpSocket.writeData(unlockData, withTimeout: -1, tag: 1)
            tcpSocket.readDataWithTimeout(-1, tag: 1)
        }
        catch
        {
            print(error)
        }
    }

    func disconnectTCPSocketWithDevice(device:EV3Device)
    {
        device.stopScan()
        device._tcpSocket!.disconnect()
        devices?.removeObjectForKey(device._address!)
        if (delegate != nil) {
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate?.updateView()
            })
        }
    }

    func socket(sock:GCDAsyncSocket,host:NSString,port:UInt16)
    {
        NSLog("socket:%p didConnectToHost:%@ port:%hu", sock, host, port)
        let settings:NSMutableDictionary = NSMutableDictionary.init(capacity: 3)
        settings.setObject("Lego EV3", forKey:String(kCFStreamSSLPeerName))
    }

    func socket(sock:GCDAsyncSocket,tag:Int64)
    {
        NSLog("socket:%p didWriteDataWithTag:%ld", sock, tag)
    }

    func socket(sock:GCDAsyncSocket,data:NSData,tag:Int64)
    {
        let host = sock.connectedHost()
        let device:EV3Device = (devices?.objectForKey(host))! as! EV3Device
        device.handleReceivedData(data, tag: Int(tag))
    }

    func socketDidDisconnect(sock:GCDAsyncSocket,error:NSError)
    {
        print("socketDidDisconnect:\(sock) hash:\(sock.hash) withError:\(error)")
        var device:EV3Device?
        for aDevice in (devices?.allValues)!
        {
            if aDevice._tcpSocket == sock {
                device = aDevice as? EV3Device
            }
        }
        if (device != nil) {
            device?._isConnected = true
            devices?.removeObjectForKey(device!._address!)
            if delegate != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.updateView()
                })
            }
            dispatch_async(dispatch_get_main_queue(), {
                let alert = UIAlertView.init(title: "Caution!", message: "EV3 is disconnected!", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            })
        }
    }
}
