//
//  Volume.swift
//  NexradParser
//
//  Created by Ramy K on 8/21/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class Volume {
    let sweeps: [Sweep];
    
    init(sweeps: [Sweep]) {
        self.sweeps = sweeps;
    }
}
