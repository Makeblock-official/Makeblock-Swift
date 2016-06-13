//
//  ViewController.swift
//  DemoProject
//
//  Created by Wang Yu on 6/7/16.
//  Copyright © 2016 Makeblock. All rights reserved.
//

import UIKit
import Makeblock

var connection = BluetoothConnection()
var mBot = MBot(connection: connection)

class BluetoothDeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var deviceTableView: UITableView!
    var deviceList: [BluetoothDevice] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        deviceTableView.dataSource = self;
        deviceTableView.delegate = self;
        connection.onAvailableDevicesChanged = { devices in
            if let bleDevices = devices as? [BluetoothDevice] {
                self.deviceList = bleDevices
                self.deviceTableView.reloadData()
            }
        }
        
        connection.onConnect = {
            self.performSegueWithIdentifier("showDetails", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deviceList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let deviceCell = deviceTableView.dequeueReusableCellWithIdentifier("deviceTableView", forIndexPath: indexPath) as! BluetoothDeviceTableViewCell
        let device = deviceList[indexPath.row]
        deviceCell.nameLabel.text = "\(device.name) (\(device.distance))"
        return deviceCell
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let device = deviceList[indexPath.row]
        connection.connect(device)
    }
}

class DetailViewController: UIViewController {
    @IBOutlet weak var ultrasonicValue: UILabel!
    
    @IBAction func onDisconnect(sender: AnyObject) {
        connection.disconnect()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onMoveForward(sender: AnyObject) {
        mBot.moveForward(255)
    }
    
    @IBAction func onStopMoving(sender: AnyObject) {
        mBot.stopMoving()
    }
    
    @IBAction func onRGBLED(sender: AnyObject) {
        mBot.setRGBLED(.all, red: 255, green: 0, blue: 0)
    }
    
    @IBAction func onBeepBuzzer(sender: AnyObject) {
        mBot.setBuzzer(.C4, duration: .half)
    }
    
    @IBAction func onUltrasonic(sender: AnyObject) {
        mBot.getUltrasonicSensorValue() { value in
            self.ultrasonicValue.text = "\(value.floatValue)"
        }
    }
}

