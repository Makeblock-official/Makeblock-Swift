//
//  Connection.swift
//  Makeblock
//
//  Created by Wang Yu on 6/6/16.
//  Copyright © 2016 Makeblock. All rights reserved.
//

import Foundation

public class Device {
    public var name = ""
    public var distance: Float = 0.0
    
    public init () {
        
    }
}

public protocol Connection {
    
    var onConnect: (() -> Void)? { get set }
    var onDisconnect: (() -> Void)? { get set }
    var onAvailableDevicesChanged: (([Device]) -> Void)? { get set }
    var onReceive: ((NSData) -> Void)? { get set }
    
    func startDiscovery()
    
    func stopDiscovery()
    
    // conenct a device, and get notified when connected
    func connect(device: Device)
    
    func connectDefaultDevice()
    
    // disconnect from a device, and get notified when disconnected
    func disconnect()
    
    func send(data: NSData)
    
}


