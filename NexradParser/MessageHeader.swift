//
//  MessageHeader.swift
//  NexradParser
//
//  Created by Ramy K on 8/20/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class MessageHeader {
    var messageBlockSize: UInt16;
    var rdaRedundentChannel: UInt8;
    var messageType: UInt8;
    var idSequenceNumber: UInt16;
    var julianDate: UInt16;
    var millisecondsOfDay: UInt32;
    var numberOfSegments: UInt16;
    var messageSegmentNumber: UInt16;
    
    init(file: BinaryFile) {
        messageBlockSize = file.readInt16();
        rdaRedundentChannel = file.readByte();
        messageType = file.readByte();
        idSequenceNumber = file.readInt16();
        julianDate = file.readInt16();
        millisecondsOfDay = file.readInt32();
        numberOfSegments = file.readInt16();
        messageSegmentNumber = file.readInt16();
    }
}
