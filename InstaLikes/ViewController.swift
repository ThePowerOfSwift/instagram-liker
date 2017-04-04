//
//  ViewController.swift
//  InstaLikes
//
//  Created by Taras Markevych on 4/4/17.
//  Copyright © 2017 ITChallenge. All rights reserved.
//
import Alamofire
import SafariServices
import SwiftyJSON


let kSafariViewControllerCloseNotification = "kSafariViewControllerCloseNotification"


class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet var loginInstagramButton: UIButton!
    @IBOutlet var label: UILabel!
    @IBOutlet var logText: UILabel!
    
    
    var safariVC: SFSafariViewController?
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginInstagramButton.setTitle(NSLocalizedString("Log in with Instagram!", comment: ""), for: UIControlState())
        
        logText.isHidden = true
        label.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.safariLogin(_:)), name: NSNotification.Name(rawValue: kSafariViewControllerCloseNotification), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginInstagramButtonTapped(_ sender: UIButton) {
        print(AuthInstagram.Router.authorizationURL)
        safariVC = SFSafariViewController(url: AuthInstagram.Router.authorizationURL as URL)
        safariVC!.delegate = self
        self.present(safariVC!, animated: true, completion: nil)
    }
    
    
    func safariLogin(_ notification: Notification) {
        let notifUrl = notification.object as! URL
        print("\nnotifUrl: \(notifUrl)")
        let urlString = String(describing: notifUrl)
        let code = extractCode(urlString)
        print("code: \(code)")
        self.loginWithInstagram(code!)
    }
    
    
    func loginWithInstagram(_ code: String) {
        let request = AuthInstagram.Router.requestAccessTokenURLStringAndParms(code)
        
        Alamofire.request(request.URLString, method: .post, parameters: request.Params, encoding: JSONEncoding.default).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let data = response.result.value
                let error = response.result.error
                
                print("\nrequest: \(response.request)")
                
                if let unwrappedError = error {
                    
                    print("error: \(unwrappedError.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        self.safariVC!.dismiss(animated: true, completion: nil)
                    }
                    
                } else {
                                        print("-- data \(data!)")
                                        print("-- Instagram json: \(json)")
                    
                    let json = JSON(data!)
                    print("json: \(json)")
                    self.user = User(json: json)
                    
                    self.safariVC?.dismiss(animated: true, completion: { () -> Void in
                        
                        if let user = self.user {
                            self.label.text = String.localizedStringWithFormat(NSLocalizedString("Welcome %@, you are logged in with the Instagram user: %@", comment: ""), user.firstName, user.userName)
                            self.logText.text = String(describing: json)
                            
                            self.label.isHidden = false
                            self.logText.isHidden = false
                            
                        } else {
                            self.label.text = NSLocalizedString("Sorry you are not logged in, try again.", comment: "")
                            self.label.isHidden = false
                        }
                        self.view.invalidateIntrinsicContentSize()
                    })
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - SFSafariViewControllerDelegate
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true) { () -> Void in
            self.label.text = NSLocalizedString("You just dismissed the login view.", comment: "")
        }
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("didLoadSuccessfully: \(didLoadSuccessfully)")
    }
    
    
    // MARK: - Utils
    
    func extractCode(_ urlString: String) -> String? {
        var code: String? = nil
        let url = URL(string: urlString)
        let urlQuery = (url?.query != nil) ? url?.query : urlString
        let components = urlQuery?.components(separatedBy: "&")
        for comp in components! {
            if (comp.range(of: "code=") != nil) {
                code = comp.components(separatedBy: "=").last
            }
        }
        print("AuthCode", code)
        return code
    }
    
}
