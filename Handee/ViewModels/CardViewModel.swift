//
//  cardViewModel.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 12/2/18.
//  Copyright © 2018 Raul Fernando Gutierrez. All rights reserved.
//

//import UIKit
//
//
//protocol ProducesCardViewModel {
//    func toCardViewModel() -> CardViewModel
//}
//
//class CardViewModel {
//    let imageNames: [String]
//    let attributedString: NSAttributedString
//    let textAlignment: NSTextAlignment
//
//    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment){
//        self.imageNames = imageNames
//        self.textAlignment = textAlignment
//        self.attributedString = attributedString
//    }
//
//    fileprivate var imageIndex = 0 {
//        didSet {
//            let imageUrl = imageNames[imageIndex]
//            //let image = UIImage(named: imageName)
//            imageIndexObserver?(imageIndex, imageUrl)
//        }
//    }
//
//    var imageIndexObserver: ((Int, String?) -> ())?
//
//    func advanceToNextPhoto () {
//        imageIndex = min(imageIndex + 1, imageNames.count - 1)
//    }
//
//    func goToPreviousPhoto() {
//        imageIndex = max(0, imageIndex - 1)
//    }
//
//}

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

// View Model is supposed represent the State of our View
class CardViewModel {
    // we'll define the properties that are view will display/render out
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAlignment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    
    fileprivate var imageIndex = 0 {
        didSet {
            let imageUrl = imageNames[imageIndex]
            //            let image = UIImage(named: imageName)
            imageIndexObserver?(imageIndex, imageUrl)
        }
    }
    
    // Reactive Programming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
