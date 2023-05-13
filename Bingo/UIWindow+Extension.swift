//
//  UIWindow+Extension.swift
//  Bingo
//
//  Created by H.W. Hsiao on 2023/5/8.
//  Copyright © 2023 H.W. Hsiao. All rights reserved.
//

import UIKit

extension UIWindow
{
    var topViewController: UIViewController?
    {
        // 用遞迴的方式找到最後被呈現的view controller
        if var topVC = rootViewController
        {
            while let vc = topVC.presentedViewController
            {
                topVC = vc
            }
            return topVC
        }
        else
        {
            return nil
        }
    }
}
