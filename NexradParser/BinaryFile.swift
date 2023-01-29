//
//  BinaryFile.swift
//  NexradParser
//
//  Created by Ramy K on 8/19/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation
import SWCompression

class BinaryFile {
    var raf: Data;
    var position: Int = 0;
    
    init(path: String) {
        self.raf = try! Data(contentsOf: Bundle.main.url(forResource: path, withExtension: nil)!);
    }
    
    init(buffer: Data) {
        self.raf = buffer;
    }
    
    func skip(amount: Int) {
        position+=amount;
    }
    
    func seek(pos: Int) {
        self.position = pos;
    }
    
    func readByte() -> UInt8 {
        //print(position)
        position+=1;
        return UInt8(bigEndian: raf[position-1]);
    }
    
    func readString(length: Int) -> String {
        var bytes = Data()
        for _ in 0..<length {
            bytes.append(readByte())
        }
        
        return String(data: bytes, encoding: .utf8)!;
    }
    
    func readInt16() -> UInt16 {
        let bytes:[UInt8] = [readByte(), readByte()];
        return UInt16(bigEndian: UnsafePointer(bytes).withMemoryRebound(to: UInt16.self, capacity: 1) {
            $0.pointee
        })
    }
    
    func readInt32() -> UInt32 {
        let bytes:[UInt8] = [readByte(), readByte(), readByte(), readByte()];
        return UInt32(bigEndian: UnsafePointer(bytes).withMemoryRebound(to: UInt32.self, capacity: 1) {
            $0.pointee
        })
    }
    
    func readCode8() -> UInt8 {
        return readByte();
    }
    
    func readCode16() -> UInt16 {
        return readInt16();
    }
    
    func readScaledInteger8(precision: Float) -> Float {
        return Float(readByte()) * precision;
    }
    
    func readScaledInteger16(precision: Float) -> Float {
        return Float(readInt16()) * precision;
    }
    
    func readScaledInteger32(precision: Float) -> Float {
        return Float(readInt32()) * precision;
    }
    
    func readReal32() -> Float32 {
        let bytes:[UInt8] = [readByte(), readByte(), readByte(), readByte()];
        return Float(bitPattern: UInt32(bigEndian: bytes.withUnsafeBytes { $0.load(as: UInt32.self) }))
    }
    
    /*func readReal64() -> Float64 {
        let bytes:[UInt8] = [readByte(), readByte(), readByte(), readByte(), readByte(), readByte(), readByte(), readByte()];
        return Float(bitPattern: UInt32(UInt64(bigEndian: bytes.withUnsafeBytes { $0.load(as: UInt64.self) })))
    }*/
    
    func getSlice(start: Int, size: Int) -> BinaryFile {
        return BinaryFile(buffer: self.raf[start..<start+size]);
    }
    
    func getBuffer() -> Data {
        return raf;
    }
    
    static func decode(path: String) -> Data {
        let buffer = BinaryFile(path: path);
        var decodePosition = 0;
        
        var result = Data();
        var totalLength = 0;
        
        let headerSize = 24;
        let headerBuffer = buffer.getSlice(start: decodePosition, size: headerSize);
        
        result.append(headerBuffer.getBuffer());
        
        totalLength+=headerBuffer.getBuffer().count;
        decodePosition+=headerSize;
        
        var processor = true;
        
        while processor {
            buffer.seek(pos: decodePosition);
            let compressionSize = buffer.readInt32();
            //print(compressionSize);
            decodePosition+=4;
            
            if(decodePosition+Int(compressionSize) < buffer.getBuffer().count) {
                let buf = buffer.getSlice(start: decodePosition, size: Int(compressionSize));
                do {
                    let decompressed = try BZip2.decompress(data: buf.getBuffer());
                    result.append(decompressed);
                    
                    totalLength+=decompressed.count;
                    decodePosition+=Int(compressionSize);
                } catch {
                    print("Decomp Error!");
                }
            } else {
                let footerBuf = buffer.getSlice(start: decodePosition, size: buffer.getBuffer().count - decodePosition);
                result.append(footerBuf.getBuffer());
                totalLength+=footerBuf.getBuffer().count;
                processor = false;
            }
        }
        
        return result;
    }
}
