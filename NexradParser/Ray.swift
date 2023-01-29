//
//  Ray.swift
//  NexradParser
//
//  Created by Ramy K on 8/21/20.
//  Copyright © 2020 Ramy K. All rights reserved.
//

import Foundation

class Ray {
    let dataMoments: [GenericDataMoment];
    
    init(dataMoments: [GenericDataMoment]) {
        self.dataMoments = dataMoments;
    }
}
