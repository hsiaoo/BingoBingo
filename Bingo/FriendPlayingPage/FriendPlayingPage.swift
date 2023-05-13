//
//  FriendPlayingPage.swift
//  Bingo
//
//  Created by H.W. Hsiao on 2023/5/6.
//  Copyright © 2023 H.W. Hsiao. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class FriendPlayingPage: UIViewController
{
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func tapCloseButton(_ sender: UIButton)
    {
        PageController.shared.dismiss()
    }
}
