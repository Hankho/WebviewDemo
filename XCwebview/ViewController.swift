//
//  ViewController.swift
//  XCwebview
//
//  Created by Hankho on 2018/3/8.
//  Copyright © 2018年 Hankho. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {
    
    let mywebview = UIWebView(frame: CGRect(
        x: 0, y: 60,
        width: UIScreen.main.bounds.size.width,
        height:UIScreen.main.bounds.size.height - 60
    ))
    
    var obj:ImageRep?
    
    private let previousButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("上一页", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(red: 218/256, green: 188/256, blue: 126/256, alpha: 1)  , for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    @objc private func handlePrev() {
        mywebview.goBack()
    }
    
    private let homeButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("首页", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(red: 218/256, green: 188/256, blue: 126/256, alpha: 1)  , for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleHome), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleHome() {
        if let url = URL(string: (self.obj?.result)!) {
            let request = URLRequest(url: url)
            mywebview.loadRequest(request)
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        VersionAPIDAO.getVersion({ (obj) in
            DispatchQueue.main.async {
                self.obj = obj;
                if(obj.version != nil){
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        var myString = obj.version
                        if(myString != version){
                            let alertView = UIAlertController(title: "提示", message: "請更新版本", preferredStyle: .alert)
                            let action = UIAlertAction(title: "確定", style: .default, handler: { (alert) in
                                if let checkURL = NSURL(string: (self.obj?.downloadUrl)!) {
                                    if UIApplication.shared.openURL(checkURL as URL) {
                                        exit(0)
                                    }
                                }
                            })
                            alertView.addAction(action)
                            self.present(alertView, animated: true, completion: nil)
                            return
                        }
                    }
                }
                self.setuptopControls()
                self.setupWebview()
            }
        }) { (str) in
            DispatchQueue.main.async {
                let alert : UIAlertView = UIAlertView(title: "提示", message: "连线异常", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
        }
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        if let text = webView.request?.url?.absoluteString{
            print(text)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        if let text = webView.request?.url?.absoluteString{
            print(text)
        }
    }
    
    func setuptopControls() {
        
        let space = UIView()
        space.backgroundColor = UIColor(red: 30/256, green: 30/256, blue: 30/256, alpha: 1)
        
        let topControlsStackView = UIStackView(arrangedSubviews: [previousButton,space,homeButton])
        topControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        topControlsStackView.distribution = .fillEqually
        view.addSubview(topControlsStackView)
        NSLayoutConstraint.activate([
            topControlsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topControlsStackView.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
    
    func setupWebview() {
        
        mywebview.scalesPageToFit = true
        mywebview.contentMode = UIViewContentMode.scaleAspectFit
        mywebview.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
        mywebview.delegate = self
        self.view.addSubview(mywebview)
        if let url = URL(string: (self.obj?.result)!) {
            let request = URLRequest(url: url)
            mywebview.loadRequest(request)
        }
    }
}


