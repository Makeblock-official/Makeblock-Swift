//
//  MBot.swift
//  Makeblock
//
//  Created by Wang Yu on 6/7/16.
//  Copyright © 2016 Makeblock. All rights reserved.
//

import Foundation

/// The Class used to control a Makeblock mBot
open class MBot: MakeblockRobot {
    /// which LED Light to set when sending setRGBLED commands
    public enum RGBLEDPosition: UInt8 {
        case all = 0
        case left = 1
        case right = 2
    }
    
    /// an enum of available ports of mBot controller board
    public enum MBotPorts: UInt8 {
        case rgbled = 7, port3 = 3, port4 = 4, port1 = 1, port2 = 2, m1 = 0x09, m2 = 0x0a, lightnessSensor = 0x06
    }
    
    /// an enum of music note pitch -> frequencies
    public enum MusicNotePitch: Int {
        case c2=65, d2=73, e2=82, f2=87, g2=98, a2=110, b2=123, c3=131, d3=147, e3=165, f3=175, g3=196, a3=220, b3=247, c4=262, d4=294, e4=330, f4=349, g4=392, a4=440, b4=494, c5=523, d5=587, e5=658, f5=698, g5=784, a5=880, b5=988, c6=1047, d6=1175, e6=1319, f6=1397, g6=1568, a6=1760, b6=1976, c7=2093, d7=2349, e7=2637, f7=2794, g7=3136, a7=3520, b7=3951, c8=4186
    }
    
    /// an enum of music note duration -> milliseconds
    public enum MusicNoteDuration: Int {
        case full=1000, half=500, quarter=250, eighth=125, sixteenth=62
    }
    
    /// an enum of line-follower sensor status.
    public enum LineFollowerSensorStatus: Float {
        case leftBlackRightBlack=0.0, leftBlackRightWhite=1.0, leftWhiteRightBlack=2.0, leftWhiteRightWhite=3.0
    }
    
    /**
     Create a mBot instance.
     
     - parameter conn: a connection to send/receive messages from
     
     - returns: MBot instance
     */
    public override init(connection conn: Connection) {
        super.init(connection: conn)
    }
    
    /**
     Set the speed of both motors of the mBot
     
     - parameter leftMotor:  speed of the left motor, -255~255
     - parameter rightMotor: speed of the right motor, -255~255
     */
    open func setMotors(_ leftMotor: Int, rightMotor: Int) {
        let (leftLow, leftHigh) = IntToUInt8Bytes(leftMotor)
        let (rightLow, rightHigh) = IntToUInt8Bytes(rightMotor)
        let _ = sendMessage(.dcMotorMove, arrayOfBytes: [leftLow, leftHigh, rightLow, rightHigh])
        
    }
    
    /**
     Set the speed of a single motor of a mBot
     
     - parameter port:  which port the motor is connect to. .M1 or .M2
     - parameter speed: the speed of the motor -255~255
     */
    open func setMotor(_ port: MBotPorts, speed: Int){
        let (low, high) = IntToUInt8Bytes(speed)
        let _ = sendMessage(.dcMotor, arrayOfBytes: [port.rawValue, low, high])
    }
    
    /**
     Tell the mBot to move forward
     
     - parameter speed: the speed of moving. -255~255
     */
    open func moveForward(_ speed: Int){
        setMotors(-speed, rightMotor: speed)
    }
    
    /**
     Tell the mBot to move backward
     
     - parameter speed: the speed of moving. -255~255
     */
    open func moveBackward(_ speed: Int){
        setMotors(speed, rightMotor: -speed)
    }
    
    /**
     Tell the mBot to turn left
     
     - parameter speed: the speed of moving. -255~255
     */
    open func turnLeft(_ speed: Int){
        setMotors(speed, rightMotor: speed)
    }
    
    /**
     Tell the mBot to turn right
     
     - parameter speed: the speed of moving. -255~255
     */
    open func turnRight(_ speed: Int){
        setMotors(-speed, rightMotor: -speed)
    }
    
    /**
     Tell the mBot to stop moving
     */
    open func stopMoving(){
        setMotors(0, rightMotor: 0)
    }
    
    /**
     Set the color of on-board LEDs of the mBot
     
     - parameter position: which LED. Can be .left, .right or .all
     - parameter red:      red value (0~255)
     - parameter green:    green value (0~255)
     - parameter blue:     blue value (0~255)
     */
    open func setRGBLED(_ position: RGBLEDPosition, red: Int, green: Int, blue: Int){
        let _ = sendMessage(.rgbled, arrayOfBytes: [MBotPorts.rgbled.rawValue, 0x02, position.rawValue,
            UInt8(red), UInt8(green), UInt8(blue)])
    }
    
    /**
     Use the buzzer to play a musical note
     
     - parameter pitch:    pitch value eg. .C4 .E4
     - parameter duration: duration. Could be .full, .half, .quarter, .eighth, or .sixteenth
     */
    open func setBuzzer(_ pitch: MusicNotePitch, duration: MusicNoteDuration) {
        let (pitchLow, pitchHigh) = IntToUInt8Bytes(pitch.rawValue)
        let (durationLow, durationHigh) = IntToUInt8Bytes(duration.rawValue)
        let _ = sendMessage(.buzzer, arrayOfBytes: [pitchLow, pitchHigh, durationLow, durationHigh])
    }
    
    /**
     Read the value of the ultrasoic sensor. and Call the callback when there's value returning
     usage:
     ```
     mbot.getUltrasonicSensorValue() { value in
     print("ultrasonic sensor says \(value)")
     }
     ```
     
     - parameter port:     which port the sensor is connected to. By default .Port3
     - parameter callback: a block of code executed after we have a value. Receive a Float as the argument.
     */
    open func getUltrasonicSensorValue(_ port: MBotPorts = .port3, callback: @escaping ((Float) -> Void)) {
        let _ = sendMessage(.ultrasonicSensor, arrayOfBytes: [port.rawValue]) { value in
            callback(value.floatValue)
        }
    }
    
    /**
     Read the value of the lightness sensor. and Call the callback when there's value returning
     usage:
     ```
        mbot.getLightnessSensorValue() { value in
            print("lightness sensor says \(value)")
        }
     ```
     
     - parameter port:     which port the sensor is connected to. By default .LightnessSensor (on board sensor)
     - parameter callback: a block of code executed after we have a value. Receive a Float as the argument.
     */
    open func getLightnessSensorValue(_ port: MBotPorts = .lightnessSensor, callback: @escaping ((Float) -> Void)) {
        let _ = sendMessage(.lightnessSensor, arrayOfBytes: [port.rawValue]) { value in
            callback(value.floatValue)
        }
    }
    
    /**
     Read the value of the line-follower sensor. and Call the callback when there's value returning
     usage:
     ```
     mbot.getLinefollowerSensorValue() { value in
        if(value == .LeftBlackRightBlack) {
            // do things when the line-follower is left-black-right-black
        }
     }
     ```
     
     - parameter port:     which port the sensor is connected to. By default .Port2 (on board sensor)
     - parameter callback: a block of code executed after we have a value. Receive a LineFollowerSensorStatus as the argument.
     */
    open func getLinefollowerSensorValue(_ port: MBotPorts = .port2, callback:@escaping ((LineFollowerSensorStatus) -> Void)) {
        let _ = sendMessage(.lineFollowerSensor, arrayOfBytes: [port.rawValue]) { value in
            callback(LineFollowerSensorStatus.init(rawValue: value.floatValue)!)
        }
    }
    
    func IntToUInt8Bytes(_ value: Int) -> (UInt8, UInt8){
        let lowValue = UInt8(value & 0xff)
        let highValue = UInt8((value >> 8) & 0xff)
        return (lowValue, highValue)
    }
}
