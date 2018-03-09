//
//  ViewController.swift
//  XCwebview
//
//  Created by Hankho on 2018/3/8.
//  Copyright © 2018年 Hankho. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate {
    
    var obj:ImageRep?
    
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
                                if let checkURL = NSURL(string: "https://itunes.apple.com/tw/app/bbin/id1149782445?mt=8") {
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
              
                    let mywebview = UIWebView(frame: CGRect(
                        x: 0, y: 70,
                        width: UIScreen.main.bounds.size.width,
                        height:UIScreen.main.bounds.size.height - 70
                        ))
            
                mywebview.scalesPageToFit = true
                mywebview.contentMode = UIViewContentMode.scaleAspectFit
                mywebview.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
      
                mywebview.delegate = self
                self.view.addSubview(mywebview)
                self.setuptopControls()
                if let url = URL(string: (self.obj?.result)!) {
                    let request = URLRequest(url: url)
                    mywebview.loadRequest(request)
                }
                
                
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
            if (text == "http://zsbet.net/Games/LoginBBIN.aspx?gametype=slot") {
                if let url = URL(string: "http://zsbet.net/mobile/Games/slot.aspx") {
                    UIApplication.shared.open(url)
                    webView.goBack()
                }
            }
        }
        
        func webViewDidFinishLoad(_ webView: UIWebView) {
            HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
            if let text = webView.request?.url?.absoluteString{
                print(text)
                
            }
        }
    }
    
    func setuptopControls() {
        
        let prevbutton = UIView()
        prevbutton.backgroundColor = .red
        
        let homebutton = UIView()
        homebutton.backgroundColor = .blue
        
        let topControlsStackView = UIStackView(arrangedSubviews: [prevbutton,homebutton])
        topControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        topControlsStackView.distribution = .fillEqually
        view.addSubview(topControlsStackView)
        NSLayoutConstraint.activate([
            topControlsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topControlsStackView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
}


