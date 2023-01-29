//
//  Sweep.swift
//  NexradParser
//
//  Created by Ramy K on 8/21/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class Sweep {
    var elevation = 0;
    var rays: [Ray];
    
    init() {
        elevation = 0;
        rays = [];
    }
}
