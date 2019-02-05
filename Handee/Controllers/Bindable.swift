//
//  Bindable.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 1/10/19.
//  Copyright © 2019 Raul Fernando Gutierrez. All rights reserved.
//
import UIKit

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
