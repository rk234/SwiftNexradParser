//
//  Message31Header.swift
//  NexradParser
//
//  Created by Ramy K on 8/20/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class Message31Header {
    var initPosition: Int;
    var stationIdentifier: String;
    var collectionTime: UInt32;
    var collectionDate: UInt16;
    var azimuthNumber: UInt16;
    var azimuthAngle: Float32;
    var compressionIndicator: UInt8;
    var radialLength: UInt16;
    var azimuthResolutionSpacing: UInt8;
    var radialStatus: UInt8;
    var elevationNumber: UInt8;
    var cutSectorNumber: UInt8;
    var elevationAngle: Float32;
    var radialSpotBlankingStatus: UInt8;
    var azimuthIndexingMode: Float;
    var dataBlockCount: UInt16;
    
    var volumeDCTPointer: UInt32;
    var elevationDCTPointer: UInt32;
    var radialDCTPointer: UInt32;
    
    var refPointer: UInt32;
    var velPointer: UInt32;
    var swPointer: UInt32;
    var zdrPointer: UInt32;
    var phiPointer: UInt32;
    var rhoPointer: UInt32;
    
    var dataBlockPointers: [UInt32];
    
    init(file: BinaryFile) {
        initPosition = file.position;
        stationIdentifier = file.readString(length: 4);
        collectionTime = file.readInt32();
        collectionDate = file.readInt16();
        azimuthNumber = file.readInt16();
        azimuthAngle = file.readReal32();
        compressionIndicator = file.readCode8();
        file.skip(amount: 1);
        radialLength = file.readInt16();
        azimuthResolutionSpacing = file.readCode8();
        radialStatus = file.readCode8();
        elevationNumber = file.readByte();
        cutSectorNumber = file.readByte();
        elevationAngle = file.readReal32();
        radialSpotBlankingStatus = file.readCode8();
        azimuthIndexingMode = file.readScaledInteger8(precision: 0.01);
        
        dataBlockCount = file.readInt16();
        volumeDCTPointer = file.readInt32();
        elevationDCTPointer = file.readInt32();
        radialDCTPointer = file.readInt32();
        refPointer = file.readInt32();
        velPointer = file.readInt32();
        swPointer = file.readInt32();
        zdrPointer = file.readInt32();
        phiPointer = file.readInt32();
        rhoPointer = file.readInt32();
        dataBlockPointers = [refPointer, velPointer, swPointer, zdrPointer, phiPointer, rhoPointer];
    }
}
