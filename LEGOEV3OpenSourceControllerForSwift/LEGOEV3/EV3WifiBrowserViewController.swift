//
//  EV3WifiBrowserViewController.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

class EV3WifiBrowserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,EV3WifiManagerDelegate {

    var tableView:UITableView?
    var doneButton:UIBarButtonItem?
    var ev3WifiManager:EV3WifiManager?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.


        viewConfiguration()


        ev3WifiManager = EV3WifiManager.sharedInstance()
        ev3WifiManager?.delegate = self

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.ev3DeviceConnected(_:)), name: "EV3DeviceConnectedNotification", object: nil)

        ev3WifiManager?.startUdpSocket()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewConfiguration()
    {
        self.view.backgroundColor = UIColor .whiteColor()

        let viewFrame:CGRect = self.view.frame
        tableView = UITableView.init(frame: CGRectMake(0, 64, viewFrame.size.width, viewFrame.size.height - 64), style: .Grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)

        let navigationBar:UINavigationBar = UINavigationBar.init(frame: CGRectMake(0, 0, viewFrame.size.width, 64))
        self.view.addSubview(navigationBar)

        let cancelButton:UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Cancel, target: self, action: #selector(self.cancel(_:)))

        doneButton = UIBarButtonItem.init(barButtonSystemItem: .Done, target: self, action: #selector(self.done(_:)))
        doneButton?.enabled = false

        let item:UINavigationItem = UINavigationItem()
        item.leftBarButtonItem = cancelButton
        item.rightBarButtonItem = doneButton;
        navigationBar.pushNavigationItem(item, animated: true)
    }

    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    func cancel(item:UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        ev3WifiManager?.stopUdpSocket()
        NSLog("Stopped Udp Echo server")
    }

    func done(item:UIBarButtonItem)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
        ev3WifiManager?.stopUdpSocket()
        NSLog("Stopped Udp Echo server")
    }

    func update()
    {
        tableView?.reloadData()
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "EV3 Lists:"
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let count:Int?
        if ev3WifiManager?.devices.count == nil {
            count = 0
        }
        else
        {
            count = ev3WifiManager?.devices.count
        }
        return count! + 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cells")

        if cell == nil {
            cell = UITableViewCell.init(style:.Subtitle, reuseIdentifier: "Cells")
        }

        if indexPath.row < ev3WifiManager?.devices.count {
            let device:EV3Device = ((self.ev3WifiManager?.devices.allValues)! as NSArray).objectAtIndex(indexPath.row) as! EV3Device
            cell!.textLabel?.text = device.address
            cell!.accessoryView = nil
            if device.isConnected == true {
                cell!.accessoryType = .Checkmark
            }
            else
            {
                cell!.accessoryType = .None
            }
        }
        else
        {
            cell!.textLabel?.text = "Searching..."
            let indicator:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .Gray)
            indicator.hidesWhenStopped = true
            cell!.accessoryView = indicator
            indicator.startAnimating()
        }

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if ev3WifiManager?.devices.count != nil {
            let device:EV3Device = ((self.ev3WifiManager?.devices.allValues)! as NSArray).objectAtIndex(indexPath.row) as! EV3Device
            NSLog("device ip:%@",device.address)
            update()
            if device.isConnected == false {
                ev3WifiManager?.connectTCPSocketWithDevice(device)
            }
            else
            {
                let alertView:UIAlertView = UIAlertView.init(title: "Alert", message: "Do you want to disconnect?", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK", "")
                alertView.tag = Int(device.tag)
                alertView.show()
            }
        }
    }

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            var device:EV3Device?
            for aDevice in (ev3WifiManager?.devices.allValues)! {
                if aDevice.tag == alertView.tag {
                    device = aDevice as? EV3Device
                }
            }
            ev3WifiManager?.disconnectTCPSocketWithDevice(device)
        }
    }

    func updateView() {
        update()
    }

    func ev3DeviceConnected(notification:NSNotification)
    {
        let device:EV3Device = notification.object as! EV3Device
        let cell:UITableViewCell = (tableView?.cellForRowAtIndexPath(NSIndexPath.init(forRow: Int(device.tag), inSection: 0)))!
        cell.accessoryType = .Checkmark
        update()
        doneButton?.enabled = true
    }
}
