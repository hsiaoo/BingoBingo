//
//  NumberButtonsView.swift
//  Bingo
//
//  Created by H.W. Hsiao on 2023/5/6.
//  Copyright © 2023 H.W. Hsiao. All rights reserved.
//

import UIKit

class NumberButtonsView: UIView
{
    @IBOutlet var contentView: UIView!
    @IBOutlet var numberButtons: [UIButton]!
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        Bundle.main.loadNibNamed("\(NumberButtonsView.self)", owner: self)
        self.contentView.frame = bounds
        addSubview(self.contentView)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        setButtonNumber()
    }
    
    private func setButtonNumber()
    {
        var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25]
        
        for i in 0 ... 24
        {
            guard
                let number = numbers.randomElement(),
                i < self.numberButtons.count
            else { return }
            
            let button = self.numberButtons[i]
//            button.setImage(UIImage(named: number.description), for: .normal)
            button.setTitle(number.description, for: .normal)
            
            if let index = numbers.firstIndex(of: number)
            {
                numbers.remove(at: index)
            }
        }
    }
    
}
