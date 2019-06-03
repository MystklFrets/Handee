//
//  MatchesNavBar.swift
//  Handee
//
//  Created by Raul Fernando Gutierrez on 6/2/19.
//  Copyright © 2019 Raul Fernando Gutierrez. All rights reserved.
//

import UIKit
import LBTATools

class MatchesNavBar: UIView {
    
     let backButton = UIButton(image: #imageLiteral(resourceName: "handeeLogo"), tintColor: .gray)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        let iconImageView = UIImageView(image: #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        iconImageView.tintColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        let messageLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1), textAlignment: .center)
        
        let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), textAlignment: .center)
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        stack(iconImageView.withHeight(44), hstack(messageLabel, feedLabel, distribution: .fillEqually)).padTop(10)
        
       
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 34, height: 34))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
