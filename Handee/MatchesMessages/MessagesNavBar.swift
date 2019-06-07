//
//  MessagesNavBar.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 6/5/19.
//  Copyright © 2019 Raul Fernando Gutierrez. All rights reserved.
//

import LBTATools

class MessagesNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "handeeLogo"))
    let nameLabel = UILabel(text: "USERNAME", font: .systemFont(ofSize: 16))
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "app_icon1"), tintColor: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "app_icon1"), tintColor: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        
        nameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        
        super.init(frame: .zero)
        backgroundColor = .white
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        let middleStack = hstack(
            stack(
                userProfileImageView,
                nameLabel,
                spacing: 8,
                alignment: .center),
            alignment: .center
        )
        
        hstack(backButton,
               middleStack,
               flagButton).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}


