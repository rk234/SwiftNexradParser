//
//  main.swift
//  NexradParser
//
//  Created by Ramy K on 8/19/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

/*let startTime = DispatchTime.now();
let data = BinaryFile(buffer: BinaryFile.decode(path: "KCAE"));
let endTime = DispatchTime.now();

print("Parse Time: \(Double(endTime.uptimeNanoseconds-startTime.uptimeNanoseconds) / 1_000_000_000)");

print(data.readString(length: 9));
print(data.readString(length: 3));

print(data.readInt32());
print(data.readInt32());

print(data.readString(length: 4));

//Skip Metadata
data.skip(amount: 134 * 2432)

var sweeps: [Sweep] = [];
for _ in 0..<1 {
    let sweep = Sweep();
    for _ in 0..<720 {
        data.skip(amount: 12);
        let messageHeader = MessageHeader(file: data);
        //print(messageHeader.messageType);
        switch messageHeader.messageType {
        case 31:
            let msg31 = Message31Header(file: data);
            if sweep.elevation == 0 {
                sweep.elevation = Int(msg31.elevationNumber);
            }
            
            var datamoments: [GenericDataMoment] = []
            
            let v = VolumeDataConstantType(buffer: data, offset: msg31.initPosition + Int(msg31.volumeDCTPointer));
            let e = ElevationDataConstantType(buffer: data, offset:  msg31.initPosition + Int(msg31.elevationDCTPointer));
            let r = RadialDataConstantType(buffer: data, offset: msg31.initPosition + Int(msg31.radialDCTPointer));
            
            for i in 0..<Int(msg31.dataBlockCount-3) {
                datamoments.append(GenericDataMoment(buffer: data, offset: msg31.initPosition + Int(msg31.dataBlockPointers[i]), azimuth: msg31.azimuthAngle));
            }
            sweep.rays.append(Ray(dataMoments: datamoments))
            break;
        case 2:
            let msg2 = Message2Header(file: data);
            data.skip(amount: 2432 - 16 - 54 - 12);
            print("Message 2!");
            break;
        default:
            data.skip(amount: Int(messageHeader.messageBlockSize));
            break;
        }
        sweeps.append(sweep);
    }
}

let vol: Volume = Volume(sweeps: sweeps);

print(vol.sweeps[0].rays[0].dataMoments[0].dataMomentName);
print("===Ray Data===")
for val in vol.sweeps[0].rays[1].dataMoments[0].dataMoments {
    print(val);
}*/

let startTime = DispatchTime.now();
let radar = Level2Archive(path: "KCAE");
let endTime = DispatchTime.now();

print("Parse Time: \(Double(endTime.uptimeNanoseconds-startTime.uptimeNanoseconds) / 1_000_000_000)");

print("Finished Decode: \(radar.station)");
print("Volume Coverage Pattern: \(radar.vcp)");

print(radar.volume.sweeps[0].rays[0].dataMoments[1].dataMomentName);
