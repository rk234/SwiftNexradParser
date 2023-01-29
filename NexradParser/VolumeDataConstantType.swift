//
//  VolumeDataConstantType.swift
//  NexradParser
//
//  Created by Ramy K on 8/21/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class VolumeDataConstantType {
    let dataBlockType: String;
    let dataName: String;
    let lrtup: UInt16;
    let majorVersionNumber: UInt8;
    let minorVersionNumber: UInt8;
    let lat: Float;
    let long: Float;
    let siteHeight: Float;
    let feedHornHeight: UInt16;
    let calibrationConstant: Float;
    let horizontalShvTxPower: Float;
    let verticalShvTxPower: Float;
    let systemDifferentialReflectivity: Float;
    let initialSystemDifferentialPhase: Float;
    let volumeCoveragePatternNumber: UInt16;
    let processingStatus: UInt16;
    
    init(buffer: BinaryFile, offset: Int) {
        buffer.seek(pos: offset);
        self.dataBlockType = buffer.readString(length: 1);
        self.dataName = buffer.readString(length: 3);
        self.lrtup = buffer.readInt16();
        self.majorVersionNumber = buffer.readByte();
        self.minorVersionNumber = buffer.readByte();
        self.lat = buffer.readReal32();
        self.long = buffer.readReal32();
        self.siteHeight = buffer.readScaledInteger16(precision: 1);
        self.feedHornHeight = buffer.readInt16();
        self.calibrationConstant = buffer.readReal32();
        self.horizontalShvTxPower = buffer.readReal32();
        self.verticalShvTxPower = buffer.readReal32();
        self.systemDifferentialReflectivity = buffer.readReal32();
        self.initialSystemDifferentialPhase = buffer.readReal32();
        self.volumeCoveragePatternNumber = buffer.readInt16();
        self.processingStatus = buffer.readInt16();
    }
}
