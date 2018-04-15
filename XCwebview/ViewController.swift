//
//  ViewController.swift
//  XCwebview
//
//  Created by Hankho on 2018/3/8.
//  Copyright © 2018年 Hankho. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {
    
    let mybutton = UIButton()
    
    
    let blockimage:UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 65, width: UIScreen.main.bounds.size.width, height: 85)
        view.backgroundColor = UIColor(red: 8/256, green: 8/256, blue: 8/256, alpha: 1)
        return view
    }()
    
    let mywebview = UIWebView(frame: CGRect(
        x: 0, y: 0,
        width: UIScreen.main.bounds.size.width,
        height:UIScreen.main.bounds.size.height - 0
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
    //回首頁function
    @objc private func handleHome() {
        if let url = URL(string: (self.obj?.result)!) {
            let request = URLRequest(url: url)
            mywebview.loadRequest(request)
        }
        blockimage.isHidden = true
        mybutton.backgroundColor = UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1)
        mybutton.frame = CGRect(x:0, y: self.view.frame.height*10/11, width: self.view.frame.width/5, height: self.view.frame.height/11)
        mybutton.setTitleColor(UIColor(red: 218/256, green: 188/256, blue: 126/256, alpha: 1),for: UIControlState())
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
                //self.setuptopControls()
                self.setupWebview()
                self.view.addSubview(self.blockimage)
                self.blockimage.isHidden = true
                self.mybutton.setTitle("首页", for: UIControlState())
                self.mybutton.frame = CGRect(x:0, y: self.view.frame.height*10/11, width: self.view.frame.width/5, height: self.view.frame.height/11)
                self.mybutton.titleLabel!.font = UIFont(name: "MicrosoftYaHei-Bold",size: 30)
                self.mybutton.setTitleColor(UIColor(red: 218/256, green: 188/256, blue: 126/256, alpha: 1),for: UIControlState())
                self.mybutton.layer.cornerRadius = 5
                self.mybutton.layer.borderWidth = 1
                self.mybutton.backgroundColor = UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 1)
                self.mybutton.layer.borderColor = UIColor(red: 218/256, green: 188/256, blue: 126/256, alpha: 1).cgColor
                self.mybutton.addTarget(self, action: #selector(self.handleHome), for: .touchUpInside)
                self.view.addSubview(self.mybutton)
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
            blockimage.isHidden = true
            if(text == "http://777.wynn660.net/m/new/#/home"){
                blockimage.isHidden = false
            }
            //離開電子遊戲後返回電子大廳
            if (text == "http://777.wynn660.net/m/new/#/game"){
                if let url = URL(string: (self.obj?.result)!+"Mobile/Games/BBINslot.aspx") {
                    let request = URLRequest(url: url)
                    mywebview.loadRequest(request)
                }
            }
            //離開捕魚遊戲後返回捕魚大廳
            if (text == "http://777.wynn660.net//m/new/#/fisharea"){
                if let url = URL(string: (self.obj?.result)!+"Mobile/Games/slotFish.aspx") {
                    let request = URLRequest(url: url)
                    mywebview.loadRequest(request)
                }
            }
            //離開捕魚遊戲後返回捕魚大廳
            if (text == "http://777.wynn660.net/m/new/#/fisharea"){
                if let url = URL(string: (self.obj?.result)!+"Mobile/Games/slotFish.aspx") {
                    let request = URLRequest(url: url)
                    mywebview.loadRequest(request)
                }
            }
            //一律不返回bbin大廳直接回本站
            if (text == "http://777.wynn660.net/m/new/#/basic"){
                if let url = URL(string: (self.obj?.result)!) {
                    let request = URLRequest(url: url)
                    mywebview.loadRequest(request)
                }
            }
            //進入遊戲後返回button改樣式
            if (text == "http://777.wynn660.net/m/bcsport" || text == "https://cb.kubet888.net/USR/SD/Portal.jsp" || text == "http://mem.wynn669.net/mobile/game.php?uid=0c7118aa1ba845f1b41a38e93c5da1cdm81l610&gtype=LT" || text == "http://66660xpj.com/Games/LoginEGL.aspx?gametype=lott_m" || text == "http://66660xpj.com/Games/LoginESP.aspx?gametype=lott_m"){
                mybutton.backgroundColor = UIColor(red: 118/256, green: 0/256, blue: 10/256, alpha: 0.5)
                mybutton.frame = CGRect(x:10, y: self.view.frame.height*10/11-45, width: self.view.frame.width/5, height: self.view.frame.height/11)
                mybutton.setTitleColor(UIColor(red: 256/256, green: 256/256, blue: 256/256, alpha: 1),for: UIControlState())
            }
            if (text == "http://dg.vrbetapi.com/Bet/Index/3"){
                mybutton.backgroundColor = UIColor(red: 118/256, green: 0/256, blue: 10/256, alpha: 0.5)
                mybutton.frame = CGRect(x:0, y: self.view.frame.height*10/11-120, width: self.view.frame.width/5, height: self.view.frame.height/11)
                mybutton.setTitleColor(UIColor(red: 256/256, green: 256/256, blue: 256/256, alpha: 1),for: UIControlState())
            }
            //進入BBIN體育&彩票後button隱藏
            if (text == "http://777.wynn660.net/m/main" || text == "http://lt.wynn660.net/member/mobile_index.php?lang=zh-cn&gtype=LT" ){
                mybutton.isHidden = true
            }
            else{
                mybutton.isHidden = false
            }
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
            topControlsStackView.heightAnchor.constraint(equalToConstant: 30)
            ])
    }
    
    func setupWebview() {
        
        mywebview.scalesPageToFit = true
        mywebview.contentMode = UIViewContentMode.scaleAspectFit
        mywebview.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
        mywebview.delegate = self
        self.view.addSubview(mywebview)
        if let url = URL(string: (self.obj?.result)!) {
            //if let url = URL(string: (self.obj?.result)!) {
            let request = URLRequest(url: url)
            mywebview.loadRequest(request)
        }
    }
}


