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
    
    let service = "bingo-bingo"
    let peerId = MCPeerID(displayName: UIDevice.current.name)
    var session: MCSession?
    var advertiserAssistant: MCAdvertiserAssistant?
    var browserViewController: MCBrowserViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setMultipeerConnectivity()
    }
    
    // MARK: - Private method
    private func setMultipeerConnectivity()
    {
        self.session = MCSession(peer: self.peerId, securityIdentity: nil, encryptionPreference: .required)
        self.session?.delegate = self
        
        guard let session else { return }
        
        self.advertiserAssistant = MCAdvertiserAssistant(
            serviceType: service,
            discoveryInfo: nil,
            session: session)
        
        self.browserViewController = MCBrowserViewController(serviceType: self.service, session: session)
        self.browserViewController?.delegate = self
    }
    
    private func startBrowsing()
    {
        guard let browser = browserViewController else { return }
        
        present(browser, animated: true)
    }
    
    private func stopBrowsing()
    {
        self.browserViewController?.dismiss(animated: true)
    }
    
    private func startAdvertising()
    {
        self.advertiserAssistant?.start()
    }
    
    private func stopAdvertising()
    {
        self.advertiserAssistant?.stop()
    }
    
    private func sendMessage(_ message: String)
    {
        guard
            let session = self.session,
            !session.connectedPeers.isEmpty
        else { return }
        
        if let data = message.data(using: .utf8)
        {
            do
            {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch let error as NSError {
                print("\(error.localizedDescription)")
            }
        }
    }
}

// MARK: - MCSessionDelegate
extension FriendPlayingPage: MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        switch state
        {
        case .connected:
            print("connected \(peerID.displayName)")
        case .connecting:
            print("connecting \(peerID.displayName)")
        case .notConnected:
            print("not connected \(peerID.displayName)")
        default:
            print("unknown status for \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        let receivedMessage = String(data: data, encoding: .utf8) ?? ""
        
        guard !receivedMessage.isEmpty else { return }
        
        DispatchQueue.main.async
        {
            self.messageTextField.text = receivedMessage
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
    {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?)
    {
    }
}

// MARK: - MCBrowserViewControllerDelegate
extension FriendPlayingPage: MCBrowserViewControllerDelegate
{
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController)
    {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController)
    {
        // 按下browser Cancel按鈕後會觸發
        dismiss(animated: true)
    }
}
