//
//  ConfigurationPage.swift
//  Bingo
//
//  Created by H.W. Hsiao on 2023/5/7.
//  Copyright © 2023 H.W. Hsiao. All rights reserved.
//

import UIKit

class ConfigurationPage: UIViewController
{
    @IBOutlet weak var buttonHost: UIButton!
    @IBOutlet weak var buttonJoin: UIButton!
    
    enum Segue: String
    {
        case ToFriendPlayingPage
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.buttonHost.layer.cornerRadius = self.buttonHost.frame.height / 2
        self.buttonJoin.layer.cornerRadius = self.buttonJoin.frame.height / 2
    }
    
    @IBAction func hostSession(_ sender: UIButton)
    {
    }
    
    @IBAction func joinSession(_ sender: UIButton)
    {
    }
}
