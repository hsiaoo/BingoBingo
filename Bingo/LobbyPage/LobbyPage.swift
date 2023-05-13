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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buttonSystem: UIButton!
    @IBOutlet weak var buttonFriend: UIButton!
    @IBOutlet weak var buttonHost: UIButton!
    @IBOutlet weak var buttonJoin: UIButton!
    @IBOutlet weak var buttonLastStep: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonDisconnect: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        MultipeerController.shared.setDelegate(self)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        self.buttonSystem.layer.cornerRadius = self.buttonSystem.frame.height / 2
        self.buttonFriend.layer.cornerRadius = self.buttonFriend.frame.height / 2
        self.buttonHost.layer.cornerRadius = self.buttonHost.frame.height / 2
        self.buttonJoin.layer.cornerRadius = self.buttonJoin.frame.height / 2
        self.buttonLastStep.layer.cornerRadius = self.buttonLastStep.frame.height / 2
        self.buttonPlay.layer.cornerRadius = self.buttonPlay.frame.height / 2
        self.buttonDisconnect.layer.cornerRadius = self.buttonDisconnect.frame.height / 2
    }
    
    @IBAction func chooseSystem(_ sender: UIButton)
    {
        performSegue(withIdentifier: Segue.ToSystemPlayingPage.rawValue, sender: nil)
    }
    
    @IBAction func chooseFriend(_ sender: Any)
    {
        // 畫面移動到MultipeerConfigView
        let multipeerConfigViewX = self.scrollView.frame.width * 1
        self.scrollView.setContentOffset(CGPoint(x: multipeerConfigViewX, y: 0), animated: true)
    }
    @IBAction func backToLastStep(_ sender: UIButton)
    {
        // 畫面移動到PlayingModeView
        let playingModeViewX = self.scrollView.frame.width * 0
        self.scrollView.setContentOffset(CGPoint(x: playingModeViewX, y: 0), animated: true)
    }
    
    @IBAction func hostSession(_ sender: UIButton)
    {
        // 顯示"等待其他人加入連線"
        // 按下accept後 前往下一頁
        // 結束advertise(?
        
        MultipeerController.shared.startAdvertising()
    }
    
    @IBAction func joinSession(_ sender: UIButton)
    {
        // 顯示browser 讓使用者選擇連線
        MultipeerController.shared.startBrowsing()
    }
    
    @IBAction func disconnectSession(_ sender: UIButton)
    {
        MultipeerController.shared.disconnectSession()
    }
}

// MARK: - MultipeerControllerDelegate
extension LobbyPage: MultipeerControllerDelegate
{
    func multipeerControllerDidJoinSession(_ sender: MultipeerController)
    {
        // 連線完成後開啟FriendPlayingPage
        self.performSegue(withIdentifier: Segue.ToFriendPlayingPage.rawValue, sender: nil)
    }
    
    func multipeerControllerDidConnect(peer ID: String)
    {
        DispatchQueue.main.async
        {
            self.buttonHost.isHidden = true
            self.buttonJoin.isHidden = true
            self.buttonDisconnect.isHidden = false
            self.buttonPlay.isHidden = false
            
            self.buttonPlay.setTitle("和\(ID)玩", for: .normal)
        }
    }
    
    func multipeerControllerDidDisconnect(peer ID: String)
    {
        DispatchQueue.main.async
        {
            self.buttonHost.isHidden = false
            self.buttonJoin.isHidden = false
            self.buttonDisconnect.isHidden = true
            self.buttonPlay.isHidden = true
        }
    }
}
