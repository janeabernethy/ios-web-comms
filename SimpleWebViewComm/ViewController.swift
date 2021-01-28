//
//  ViewController.swift
//  SimpleWebViewComm
//
//  Created by Jane Abernethy on 27/1/21.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    let webview = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webview)
       
        //1. Load the html into the webview
            //get path to html file
        let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
        let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
        
        // load html file in webview
        webview.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl.deletingLastPathComponent())

        //2. set up the messaging - these lines are needed so that this file can recieve messages from the webview.
        //view controller can recieve messages with the name "changeColor"
        self.webview.configuration.userContentController.add(self, name: "changeColor")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webview.frame = self.view.bounds
    }

}
extension ViewController: WKScriptMessageHandler {

    //4. this is where the native code intercepts any messages sent from the webcode.
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {

        let colorList = ["red", "green", "blue", "orange", "magenta"]
        let selectedColor = colorList.randomElement()!

        //5. this is where the native code calls the webcode

        let javascriptString = "changeBackgroundColor('" + selectedColor + "')";
        webview.evaluateJavaScript(javascriptString) { (_, error) in
            if let error = error {
                print(error)
            }
        }
    }
}


