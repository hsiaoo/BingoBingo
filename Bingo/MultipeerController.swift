//
//  MultipeerController.swift
//  Bingo
//
//  Created by H.W. Hsiao on 2023/5/8.
//  Copyright © 2023 H.W. Hsiao. All rights reserved.
//

import MultipeerConnectivity

protocol MultipeerControllerDelegate: AnyObject
{
    func multipeerControllerDidJoinSession(_ sender: MultipeerController)
    func multipeerControllerDidConnect(peer ID: String)
    func multipeerControllerDidDisconnect(peer ID: String)
}

class MultipeerController: NSObject
{
    static let shared = MultipeerController()
    
    private override init()
    {
        super.init()
        setMultipeerConnectivity()
    }
    
    let service = "bingo-bingo"
    let peerId = MCPeerID(displayName: UIDevice.current.name)
    var session: MCSession?
    var advertiserAssistant: MCAdvertiserAssistant?
    var browserViewController: MCBrowserViewController?
    weak var delegate: MultipeerControllerDelegate?
    
    func setDelegate(_ delegate: MultipeerControllerDelegate)
    {
        self.delegate = delegate
    }
    
    func setMultipeerConnectivity()
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
    
    func disconnectSession()
    {
        self.session?.disconnect()
    }
    
    func startBrowsing()
    {
        // 顯示browser 讓使用者選擇連線
        guard let browser = browserViewController else { return }
        
        PageController.shared.present(browser)
    }
    
    func stopBrowsing()
    {
        self.browserViewController?.dismiss(animated: true)
    }
    
    func startAdvertising()
    {
        self.advertiserAssistant?.start()
    }
    
    func stopAdvertising()
    {
        self.advertiserAssistant?.stop()
    }
    
    func sendMessage(_ message: String)
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
extension MultipeerController: MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        switch state
        {
        case .connected:
            print("connected \(peerID.displayName)")
            self.delegate?.multipeerControllerDidConnect(peer: peerID.displayName)
            
        case .connecting:
            print("connecting \(peerID.displayName)")
            self.delegate?.multipeerControllerDidConnect(peer: peerID.displayName)
            
        case .notConnected:
            self.delegate?.multipeerControllerDidDisconnect(peer: peerID.displayName)
            
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
//            self.messageTextField.text = receivedMessage
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
extension MultipeerController: MCBrowserViewControllerDelegate
{
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController)
    {
        // 關閉browser
        stopBrowsing()
        
        self.delegate?.multipeerControllerDidJoinSession(self)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController)
    {
        // 按下browser Cancel按鈕後會觸發
        
        // 關閉browser
        stopBrowsing()
        
        // 告知使用者無連線（？
    }
}
