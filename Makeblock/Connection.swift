//
//  Connection.swift
//  Makeblock
//
//  Created by Wang Yu on 6/6/16.
//  Copyright © 2016 Makeblock. All rights reserved.
//

import Foundation

/// A representation for (bluetooth or 2.4G) device associated with a mBot
public class Device {
    /// The name of the robot
    public var name = ""
    /// the distance from the robot to the iOS/OSX device
    public var distance: Float = 0.0
    
    public init () {
        
    }
}

/**
 *  The protocol for a (Bluetooth or 2.4G) Connection
 */
public protocol Connection {
    
    /// Callback when a device is connected
    var onConnect: (() -> Void)? { get set }
    
    /// Callback when a device is disconnected
    var onDisconnect: (() -> Void)? { get set }
    
    /// Callback when the available device list is changed 
    /// (Maybe new device is discovered or an old one disappeared)
    var onAvailableDevicesChanged: (([Device]) -> Void)? { get set }
    
    /// Callback when the connect received data
    var onReceive: ((NSData) -> Void)? { get set }
    
    /**
     start discovering devices
     */
    func startDiscovery()
    
    /**
     stop discovering devices
     */
    func stopDiscovery()
    
    // conenct a device, and get notified when connected
    func connect(device: Device)
    
    /**
     try to connect to a random device
     */
    func connectDefaultDevice()
    
    // disconnect from a device, and get notified when disconnected
    func disconnect()
    
    /**
     send data through the connection
     
     - parameter data: the data to be sent
     */
    func send(data: NSData)
    
}


