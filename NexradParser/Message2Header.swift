//
//  Message2Header.swift
//  NexradParser
//
//  Created by Ramy K on 8/20/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class Message2Header {
    init(file: BinaryFile) {
        file.skip(amount: 54);
    }
}
