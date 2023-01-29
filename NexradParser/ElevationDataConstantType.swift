//
//  ElevationDataConstantType.swift
//  NexradParser
//
//  Created by Ramy K on 8/21/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class ElevationDataConstantType {
    let dataBlockType: String;
    let dataName: String;
    let lrtup: UInt16;
    let atmos: Float;
    let calibrationConstant: Float;
    
    init(buffer: BinaryFile, offset: Int) {
        buffer.seek(pos: offset);
        self.dataBlockType = buffer.readString(length: 1);
        self.dataName = buffer.readString(length: 3);
        self.lrtup = buffer.readInt16();
        self.atmos = buffer.readScaledInteger16(precision: 0.001);
        self.calibrationConstant = buffer.readReal32();
    }
}
