//
//  RadialDataConstantType.swift
//  NexradParser
//
//  Created by Ramy K on 8/21/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class RadialDataConstantType {
    let dataBlockType: String;
    let dataName: String;
    let lrtup: UInt16;
    let unambiguousRange: Float;
    let horizontalNoiseLevel: Float;
    let verticalNoiseLevel: Float;
    let nyquistVelocity: Float;
    let horizontalCalibrationConstant: Float;
    let verticalCalibrationConstant: Float;
    
    init(buffer: BinaryFile, offset: Int) {
        buffer.seek(pos: offset);
        self.dataBlockType = buffer.readString(length: 1);
        self.dataName = buffer.readString(length: 3);
        self.lrtup = buffer.readInt16();
        self.unambiguousRange = buffer.readScaledInteger16(precision: 0.1);
        self.horizontalNoiseLevel = buffer.readReal32();
        self.verticalNoiseLevel = buffer.readReal32();
        self.nyquistVelocity = buffer.readScaledInteger16(precision: 0.01);
        buffer.skip(amount: 2);
        self.horizontalCalibrationConstant = buffer.readReal32();
        self.verticalCalibrationConstant = buffer.readReal32();
    }
}
