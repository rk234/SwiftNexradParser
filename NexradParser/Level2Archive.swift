//
//  Level2Archive.swift
//  NexradParser
//
//  Created by Ramy K on 8/22/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class Level2Archive {
    var station: String = "";
    var latitude: Float = 0;
    var longitude: Float = 0 ;
    var scanDate: Date = Date();
    var vcp: Int = 0;
    var volume: Volume = Volume(sweeps: []);
    
    init(path: String) {
        self.volume = self.decode(path: path);
    }
    
    private func decode(path: String) -> Volume {
        let data = BinaryFile(buffer: BinaryFile.decode(path: path));
        
        data.skip(amount: 12);

        let scanDay = data.readInt32();
        let scanTime = data.readInt32();
        
        let dateFormatter = DateFormatter();
        dateFormatter.locale = Locale(identifier: "en_US_POSIX");
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
        
        self.scanDate = Date(timeInterval: TimeInterval(daysToSeconds(days: Int(scanDay)) + milliSecondsToSeconds(milli: Int(scanTime))), since: dateFormatter.date(from: "1969-12-31 23:59:59 GMT")!)
        
        print(dateFormatter.string(from: self.scanDate));

        self.station = data.readString(length: 4);

        //Skip Metadata
        data.skip(amount: 134 * 2432)

        var sweeps: [Sweep] = [];
        for _ in 0..<2 {
            let sweep = Sweep();
            for _ in 0..<720 {
                data.skip(amount: 12);
                let messageHeader = MessageHeader(file: data);
                print(messageHeader.messageType);
                switch messageHeader.messageType {
                case 31:
                    let msg31 = Message31Header(file: data);
                    if sweep.elevation == 0 {
                        sweep.elevation = Int(msg31.elevationNumber);
                    }
                    
                    var datamoments: [GenericDataMoment] = []
                    
                    let v = VolumeDataConstantType(buffer: data, offset: msg31.initPosition + Int(msg31.volumeDCTPointer));
                    
                    if longitude == 0 && latitude == 0 {
                        self.longitude = v.long;
                        self.latitude = v.lat;
                    }
                    
                    self.vcp = Int(v.volumeCoveragePatternNumber);

                    let e = ElevationDataConstantType(buffer: data, offset:  msg31.initPosition + Int(msg31.elevationDCTPointer));
                    let r = RadialDataConstantType(buffer: data, offset: msg31.initPosition + Int(msg31.radialDCTPointer));
                    
                    for i in 0..<Int(msg31.dataBlockCount-1) {
                        if msg31.dataBlockPointers[i] != 0 {
                            print(msg31.dataBlockPointers[i]);
                            datamoments.append(GenericDataMoment(buffer: data, offset: msg31.initPosition + Int(msg31.dataBlockPointers[i]), azimuth: msg31.azimuthAngle));
                        }
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

        return Volume(sweeps: sweeps);
    }
    
    func daysToSeconds(days: Int) -> Int {
        return days * 24 * 60 * 60;
    }
    
    func milliSecondsToSeconds(milli: Int) -> Int {
        return milli / 1000;
    }
}
