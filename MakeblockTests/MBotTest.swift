//
//  MBotTest.swift
//  Makeblock
//
//  Created by Wang Yu on 6/13/16.
//  Copyright © 2016 Makeblock. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Makeblock


class MBotTest: QuickSpec {
    override func spec() {
        describe("mBot") {
            it("can control motor"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                mbot.setMotor(.M1, speed: 10)
                // index of write messages are forever 0x01
                let expectedMessage: [UInt8] = [0xff, 0x55, 0x06, 0x01, 0x02, 0x0a, 0x09, 0x0a, 0x00]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
            }
            
            it("can move forward"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                mbot.moveForward(10)
                let expectedMessage: [UInt8] = [0xff, 0x55, 0x07, 0x01, 0x02, 0x05, 0xf6, 0xff, 0x0a, 0x00]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
            }
            
            it("can move backward"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                mbot.moveBackward(10)
                let expectedMessage: [UInt8] = [0xff, 0x55, 0x07, 0x01, 0x02, 0x05, 0x0a, 0x00, 0xf6, 0xff]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
            }
            
            it("can turn left"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                mbot.turnLeft(10)
                let expectedMessage: [UInt8] = [0xff, 0x55, 0x07, 0x01, 0x02, 0x05, 0x0a, 0x00, 0x0a, 0x00]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
            }
            
            it("can turn right"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                mbot.turnRight(10)
                let expectedMessage: [UInt8] = [0xff, 0x55, 0x07, 0x01, 0x02, 0x05, 0xf6, 0xff, 0xf6, 0xff]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
            }
            
            it("can stop moving"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                mbot.stopMoving()
                let expectedMessage: [UInt8] = [0xff, 0x55, 0x07, 0x01, 0x02, 0x05, 0x00, 0x00, 0x00, 0x00]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
            }
            
            it("can set RGB LED"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                mbot.setRGBLED(.all, red: 20, green: 60, blue: 150)
                let expectedMessage: [UInt8] = [0xff, 0x55, 0x09, 0x01, 0x02, 0x08, 0x07, 0x02, 0x00, 0x14, 0x3c, 0x96]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
            }
            
            it("can set buzzer"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                mbot.setBuzzer(.C4, duration: .half)
                let expectedMessage: [UInt8] = [0xff, 0x55, 0x07, 0x01, 0x02, 0x22, 0x06, 0x01, 0xf4, 0x01]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
            }
            
            it("can get ultrasonic value"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                var hasValue = false
                mbot.getUltrasonicSensorValue() { value in
                    expect(value == 74.3793106).to(beTrue())
                    hasValue = true
                }
                var expectedMessage: [UInt8] = [0xff, 0x55, 0x04, 0x01, 0x01, 0x01, 0x03]
                expectedMessage[3] = conn.sentBytes[3]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
                conn.testReceiveBytes([0xff, 0x55, expectedMessage[3], 0x02, 0x35, 0xc2, 0x94, 0x42, 0x0d, 0x0a])
                expect(hasValue).to(beTrue())
            }
            
            it("can get lightness sensor value"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                var hasValue = false
                mbot.getLightnessSensorValue() { value in
                    expect(value == 74.3793106).to(beTrue())
                    hasValue = true
                }
                var expectedMessage: [UInt8] = [0xff, 0x55, 0x04, 0x01, 0x01, 0x03, 0x06]
                expectedMessage[3] = conn.sentBytes[3]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
                conn.testReceiveBytes([0xff, 0x55, expectedMessage[3], 0x02, 0x35, 0xc2, 0x94, 0x42, 0x0d, 0x0a])
                expect(hasValue).to(beTrue())
            }
            
            it("can get line-follower value"){
                let conn = MockConnection()
                let mbot = MBot(connection: conn)
                var hasValue = false
                mbot.getLinefollowerSensorValue() { value in
                    expect(value == .LeftWhiteRightWhite).to(beTrue())
                    hasValue = true
                }
                var expectedMessage: [UInt8] = [0xff, 0x55, 0x04, 0x01, 0x01, 0x11, 0x02]
                expectedMessage[3] = conn.sentBytes[3]
                expect(expectedMessage == conn.sentBytes).to(beTrue())
                conn.testReceiveBytes([0xff, 0x55, expectedMessage[3], 0x02, 0x00, 0x00, 0x40, 0x40, 0x0d, 0x0a])
                expect(hasValue).to(beTrue())
            }
        }
    }
}