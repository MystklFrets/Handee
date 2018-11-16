//
//  HomeBottomControlsStackView.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 11/13/18.
//  Copyright © 2018 Raul Fernando Gutierrez. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let subviews = [#imageLiteral(resourceName: "refresh_circle"), #imageLiteral(resourceName: "dismiss_circle"), #imageLiteral(resourceName: "super_like_circle"), #imageLiteral(resourceName: "like_circle"), #imageLiteral(resourceName: "boost_circle")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
         heightAnchor.constraint(equalToConstant: 120).isActive = true
         distribution = .fillEqually

        subviews.forEach { (v) in
            addArrangedSubview(v)
        }

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
