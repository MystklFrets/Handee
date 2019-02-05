//
//  Advertiser.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 12/11/18.
//  Copyright © 2018 Raul Fernando Gutierrez. All rights reserved.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
    let title: String
    let brandName: String
    let posterPhotoName: String
    
    func toCardViewModel() -> CardViewModel {
        let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .heavy)])
        attributedString.append(NSMutableAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .light)]))
        return CardViewModel(imageNames: [posterPhotoName], attributedString: attributedString, textAlignment: .center)
    }
}
