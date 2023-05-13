//
//  PageController.swift
//  Bingo
//
//  Created by H.W. Hsiao on 2023/5/8.
//  Copyright © 2023 H.W. Hsiao. All rights reserved.
//

import UIKit

enum Segue: String
{
    case ToSystemPlayingPage
    case ToConfigurationPage
    case ToFriendPlayingPage
}

class PageController
{
    static let shared = PageController()
    
    private init() {}
    
    /** present頁面 */
    public func present(_ vc: UIViewController)
    {
        guard let topViewController = UIApplication.shared.keyWindow?.topViewController else { return }
        
        topViewController.present(vc, animated: true)
    }
    
    /** dismiss頁面 */
    public func dismiss()
    {
        guard let topViewController = UIApplication.shared.keyWindow?.topViewController else { return }
        
        topViewController.dismiss(animated: true)
    }
}
