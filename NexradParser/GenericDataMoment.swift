//
//  GenericDataMoment.swift
//  NexradParser
//
//  Created by Ramy K on 8/21/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class GenericDataMoment {
    let azimuth: Float;
    let dataBlockType: String;
    let dataMomentName: String;
    let numberOfDataMomentGates: UInt16;
    let dataMomentRange: Float;
    let dataMomentRangeSampleInterval: Float;
    var dataMoments: [Float];
    let tover: Float;
    let snrThreshold: Float;
    let controlFlags: UInt8;
    let dataWordSize: UInt8;
    let scale: Float;
    let offset: Float;
    
    init(buffer: BinaryFile, offset: Int, azimuth: Float) {
        self.azimuth = azimuth;
        buffer.seek(pos: offset);
        self.dataBlockType = buffer.readString(length: 1);
        self.dataMomentName = buffer.readString(length: 3);
        print(dataMomentName);
        buffer.skip(amount: 4);
        self.numberOfDataMomentGates = buffer.readInt16();
        self.dataMomentRange = buffer.readScaledInteger16(precision: 0.001);
        self.dataMomentRangeSampleInterval = buffer.readScaledInteger16(precision: 0.001);
        self.tover = buffer.readScaledInteger16(precision: 0.1);
        self.snrThreshold = buffer.readScaledInteger16(precision: 0.125);
        self.controlFlags = buffer.readCode8();
        self.dataWordSize = buffer.readByte();
        self.scale = buffer.readReal32();
        self.offset = buffer.readReal32();
        self.dataMoments = [Float](repeating: 0, count: (Int(self.numberOfDataMomentGates) * Int(self.dataWordSize)) / 8);
        for i in 0..<getSize() {
            self.dataMoments[i] = self.scaleData(val: buffer.readByte());
        }
    }
    
    func scaleData(val: UInt8) -> Float {
        if val == 0 || val == 1 {
            return -99;
        }
        //print(self.scale);
        return ((Float(val) - self.offset) / self.scale);
    }
    
    func getSize() -> Int {
        return (Int(self.numberOfDataMomentGates) * Int(self.dataWordSize)) / 8;
    }
}
