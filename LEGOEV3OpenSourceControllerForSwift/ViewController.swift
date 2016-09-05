//
//  ViewController.swift
//  LEGOEV3OpenSourceControllerForSwift
//
//  Created by 邓杰豪 on 2016/9/5.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var device:EV3Device?
    var ev3WifiManager:EV3WifiManager?
    var robotTable:UITableView?
    var robotTitleButton:UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        let robotTitleView:UIView? = UIView.init(frame: CGRectMake(0, 0, 200, 40))

        robotTitleButton = UIButton.init(type: .Custom)
        robotTitleButton?.frame = CGRectMake(0, 0, robotTitleView!.frame.size.width, robotTitleView!.frame.size.height)
        robotTitleButton?.titleLabel?.text = "点我"
        robotTitleButton?.addTarget(self, action: #selector(self.goToControlView(_:)), forControlEvents: .TouchUpInside)
        robotTitleView?.addSubview(robotTitleButton!)

        self.navigationItem.titleView = robotTitleView
        self.view.backgroundColor = UIColor.whiteColor()

        let leftBtn = UIButton.init(type: .Custom)
        leftBtn.frame = CGRectMake(0, 8, 50, 30)
        leftBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        leftBtn.setTitle("连接", forState: .Normal)
        leftBtn.addTarget(self, action: #selector(self.showLeftMenu(_:)), forControlEvents: .TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)

        ev3WifiManager = EV3WifiManager.sharedInstance()

        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.refreshData), userInfo: nil, repeats: true)

        robotTable = UITableView.init(frame: self.view.bounds, style: .Plain)
        robotTable?.dataSource = self
        robotTable?.delegate = self
        self.view.addSubview(robotTable!)

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func goToControlView(sender:UIButton)
    {
        let gogogo = PControlRobotViewController()
        gogogo.initDeviceData(device!)
        self.presentViewController(gogogo, animated: true, completion: nil)

    }

    func showLeftMenu(sender:UIButton)
    {
        let gogogo = EV3WifiBrowserViewController()
        self.presentViewController(gogogo, animated: true, completion: nil)
    }

    func refreshData()
    {
        device = ev3WifiManager?.devices!.allValues.last as? EV3Device
        robotTable?.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (device != nil) {
            return 8
        }
        else
        {
            return 1
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = PPortInfoTableViewCell.init(style: .Default, reuseIdentifier: "HELLO")
        cell.userInteractionEnabled = false

        if (device != nil) {
            switch indexPath.row {
            case 0:
                cell.portLabel!.text = "PORTA"
                cell.nameLabel!.text = String(device!.sensorPortA!.typeString)
                cell.imageView!.image = device!.sensorPortA!.image
                cell.dataLabel!.text = "Raw Data:"+String(device!.sensorPortA!.data)
                break
            case 1:
                cell.portLabel!.text = "PORTB"
                cell.nameLabel!.text = String(device!.sensorPortB!.typeString)
                cell.imageView!.image = device!.sensorPortB!.image
                cell.dataLabel!.text = "Raw Data:"+String(device!.sensorPortB!.data)
                break
            case 2:
                cell.portLabel!.text = "PORTC"
                cell.nameLabel!.text = String(device!.sensorPortC!.typeString)
                cell.imageView!.image = device!.sensorPortC!.image
                cell.dataLabel!.text = "Raw Data:"+String(device!.sensorPortC!.data)
                break
            case 3:
                cell.portLabel!.text = "PORTD"
                cell.nameLabel!.text = String(device!.sensorPortD!.typeString)
                cell.imageView!.image = device!.sensorPortD!.image
                cell.dataLabel!.text = "Raw Data:"+String(device!.sensorPortD!.data)
                break
            case 4:
                cell.portLabel!.text = "PORT1"
                cell.nameLabel!.text = String(device!.sensorPort1!.typeString)
                cell.imageView!.image = device!.sensorPort1!.image
                cell.dataLabel!.text = "Raw Data:"+String(device!.sensorPort1!.data)
                break
            case 5:
                cell.portLabel!.text = "PORT2"
                cell.nameLabel!.text = String(device!.sensorPort2!.typeString)
                cell.imageView!.image = device!.sensorPort2!.image
                cell.dataLabel!.text = "Raw Data:"+String(device!.sensorPort2!.data)
                break
            case 6:
                cell.portLabel!.text = "PORT3"
                cell.nameLabel!.text = String(device!.sensorPort3!.typeString)
                cell.imageView!.image = device!.sensorPort3!.image
                cell.dataLabel!.text = "Raw Data:"+String(device!.sensorPort3!.data)
                break
            case 7:
                cell.portLabel!.text = "PORT4"
                cell.nameLabel!.text = String(device!.sensorPort4!.typeString)
                cell.imageView!.image = device!.sensorPort4!.image
                cell.dataLabel!.text = "Raw Data:"+String(device!.sensorPort4!.data)
                break
            default:
                break
            }
        }
        else
        {
            cell.textLabel!.text = "正在等待连接EV3!"
            cell.textLabel!.textAlignment = .Center
        }
        return cell
    }
}

