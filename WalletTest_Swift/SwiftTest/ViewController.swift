//
//  ViewController.swift
//  SwiftTest
//
//  Created by 崔林豪 on 2018/8/15.
//  Copyright © 2018年 崔林豪. All rights reserved.
//

import UIKit
import PassKit

class ViewController: UIViewController {

    var passToAdd = PKPass()
    let passLibrary = PKPassLibrary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newBtn: UIButton = UIButton(frame: CGRect(x: 20, y: 50, width: 100, height: 40))
        newBtn.backgroundColor = UIColor.orange
        newBtn.setTitle("添加凭证", for: .normal)
        newBtn.addTarget(self, action: #selector(newButtonClick(_:)), for: .touchUpInside)
        self.view.addSubview(newBtn)
        
    }

    @objc func newButtonClick(_ sender: Any)
    {
        NSLog("------")
        showWalletPass(fileName: "Lollipop")
    }
    
    //显示票据
    func showWalletPass(fileName: String)  {
        guard PKPassLibrary.isPassLibraryAvailable() else {
            showAlert(message: "您的设备不支持wallet")
            return
        }
        
        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "pkpass") else {
            showAlert(message: "未找到票据凭证")
    
            return
        }
        
        guard let passData = try? Data.init(contentsOf: fileUrl) else {
            showAlert(message: "未找到票据证据")
            return
        }
        
        var error: NSError?
        let pass = PKPass(data: passData, error: &error)
        if error != nil {
            showAlert(message: "\(String(describing: error?.localizedDescription))")
            return
        }
        
        if PKAddPassesViewController.canAddPasses()
        {
            showPass(pass: pass)
        }
        else
        {
            showAlert(message: "设备不支持wallet")
        }
    }
    
    
    //提示信息
    func showAlert(message: String) {
        
        let alertVc = UIAlertController.init(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let actionConfirm = UIAlertAction.init(title: "确定", style: UIAlertActionStyle.default) { _ in
        }
        alertVc.addAction(actionConfirm)
        self.present(alertVc, animated: true, completion: nil)
    }
    
    //显示凭证信息
    func showPass(pass: PKPass)  {
        if passLibrary.containsPass(pass) {
            showAlert(message: "凭证已经添加")
            return
        }
        passToAdd = pass
        let addPassVc = PKAddPassesViewController(pass: pass)
        addPassVc.delegate = self
        
        self.present(addPassVc, animated: true, completion: nil)
    }
    
    func addfinish(message: String)  {
        //guard let守护一定有值。如果没有，直接返回
        guard passLibrary.containsPass(passToAdd) else {
            return
        }
        
        let actionConfirm = UIAlertAction.init(title: "查看", style: UIAlertActionStyle.default) { [ weak self] _ in
            guard let passURL = self?.passToAdd.passURL else
            {
                return
            }
            
            if UIApplication.shared.canOpenURL(passURL) {
                UIApplication.shared.open(passURL, options: [:], completionHandler: { _ in
                    
                })
            }
        }
        
        let actionCancel = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.default, handler: nil)
        
        let alertVc = UIAlertController.init(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertVc.addAction(actionConfirm)
        alertVc.addAction(actionCancel)
        self.present(alertVc, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: PKAddPassesViewControllerDelegate
{
    func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
        controller.dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.addfinish(message: "添加完成")
            
            
        }
    }
}



