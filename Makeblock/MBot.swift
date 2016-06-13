//
//  MBot.swift
//  Makeblock
//
//  Created by Wang Yu on 6/7/16.
//  Copyright © 2016 Makeblock. All rights reserved.
//

import Foundation

public class MBot: MakeblockRobot {
    public enum RGBLEDPosition: UInt8 {
        case all = 0
        case left = 1
        case right = 2
    }
    
    public enum MBotPorts: UInt8 {
        case RGBLED = 7, Port3 = 3, Port4 = 4, Port1 = 1, Port2 = 2, M1 = 0x09, M2 = 0x0a, LightnessSensor = 0x06
    }
    
    public enum MusicNotePitch: Int {
        case C2=65, D2=73, E2=82, F2=87, G2=98, A2=110, B2=123, C3=131, D3=147, E3=165, F3=175, G3=196, A3=220, B3=247, C4=262, D4=294, E4=330, F4=349, G4=392, A4=440, B4=494, C5=523, D5=587, E5=658, F5=698, G5=784, A5=880, B5=988, C6=1047, D6=1175, E6=1319, F6=1397, G6=1568, A6=1760, B6=1976, C7=2093, D7=2349, E7=2637, F7=2794, G7=3136, A7=3520, B7=3951, C8=4186
    }
    
    public enum MusicNoteDuration: Int {
        case full=1000, half=500, quarter=250, eighth=125, sixteenth=62
    }
    
    public enum LineFollowerSensorStatus: Float {
        case LeftBlackRightBlack=0.0, LeftBlackRightWhite=1.0, LeftWhiteRightBlack=2.0, LeftWhiteRightWhite=3.0
    }
    
    public override init(connection conn: Connection) {
        super.init(connection: conn)
    }
    
    public func setMotors(leftMotor: Int, rightMotor: Int) {
        let (leftLow, leftHigh) = IntToUInt8Bytes(leftMotor)
        let (rightLow, rightHigh) = IntToUInt8Bytes(rightMotor)
        sendMessage(.DCMotorMove, arrayOfBytes: [leftLow, leftHigh, rightLow, rightHigh])
        
    }
    
    public func setMotor(port: MBotPorts, speed: Int){
        let (low, high) = IntToUInt8Bytes(speed)
        sendMessage(.DCMotor, arrayOfBytes: [port.rawValue, low, high])
    }
    
    public func moveForward(speed: Int){
        setMotors(-speed, rightMotor: speed)
    }
    
    public func moveBackward(speed: Int){
        setMotors(speed, rightMotor: -speed)
    }
    
    public func turnLeft(speed: Int){
        setMotors(speed, rightMotor: speed)
    }
    
    public func turnRight(speed: Int){
        setMotors(-speed, rightMotor: -speed)
    }
    
    public func stopMoving(){
        setMotors(0, rightMotor: 0)
    }
    
    public func setRGBLED(position: RGBLEDPosition, red: Int, green: Int, blue: Int){
        sendMessage(.RGBLED, arrayOfBytes: [MBotPorts.RGBLED.rawValue, 0x02, position.rawValue,
            UInt8(red), UInt8(green), UInt8(blue)])
    }
    
    public func setBuzzer(pitch: MusicNotePitch, duration: MusicNoteDuration) {
        let (pitchLow, pitchHigh) = IntToUInt8Bytes(pitch.rawValue)
        let (durationLow, durationHigh) = IntToUInt8Bytes(duration.rawValue)
        sendMessage(.Buzzer, arrayOfBytes: [pitchLow, pitchHigh, durationLow, durationHigh])
    }
    
    public func getUltrasonicSensorValue(port: MBotPorts = .Port3, callback: ((Float) -> Void)) {
        sendMessage(.UltrasonicSensor, arrayOfBytes: [port.rawValue]) { value in
            callback(value.floatValue)
        }
    }
    
    public func getLightnessSensorValue(port: MBotPorts = .LightnessSensor, callback: ((Float) -> Void)) {
        sendMessage(.LightnessSensor, arrayOfBytes: [port.rawValue]) { value in
            callback(value.floatValue)
        }
    }
    
    public func getLinefollowerSensorValue(port: MBotPorts = .Port2, callback:((LineFollowerSensorStatus) -> Void)) {
        sendMessage(.LineFollowerSensor, arrayOfBytes: [port.rawValue]) { value in
            callback(LineFollowerSensorStatus.init(rawValue: value.floatValue)!)
        }
    }
    
    func IntToUInt8Bytes(value: Int) -> (UInt8, UInt8){
        let lowValue = UInt8(value & 0xff)
        let highValue = UInt8((value >> 8) & 0xff)
        return (lowValue, highValue)
    }
}