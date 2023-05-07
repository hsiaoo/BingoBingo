//
//  LobbyPage.swift
//  Bingo
//
//  Created by H.W. Hsiao on 2023/5/6.
//  Copyright © 2023 H.W. Hsiao. All rights reserved.
//

import UIKit

class LobbyPage: UIViewController
{
    @IBOutlet weak var buttonSystem: UIButton!
    @IBOutlet weak var buttonFriend: UIButton!
    
    enum Segue: String
    {
        case ToSystemPlayingPage
        case ToConfigurationPage
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.buttonSystem.layer.cornerRadius = self.buttonSystem.frame.height / 2
        self.buttonFriend.layer.cornerRadius = self.buttonFriend.frame.height / 2
    }
    
    @IBAction func chooseSystem(_ sender: UIButton)
    {
        performSegue(withIdentifier: Segue.ToSystemPlayingPage.rawValue, sender: nil)
    }
    
    @IBAction func chooseFriend(_ sender: Any)
    {
        performSegue(withIdentifier: Segue.ToConfigurationPage.rawValue, sender: nil)
    }
}
