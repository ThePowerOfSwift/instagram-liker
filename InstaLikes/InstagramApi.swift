//
//  InstagramApi.swift
//  InstaLikes
//
//  Created by Taras Markevych on 4/4/17.
//  Copyright © 2017 ITChallenge. All rights reserved.
//

import UIKit
import Alamofire

let INSTAGRAM_CLIENT_ID = "a10b5e3c3af84099bb69a373ae137893"
let INSTAGRAM_CLIENT_SECRET = "6e6249a3bc4849778ed992fcb097971d"
let INSTAGRAM_REDIRECT_URL = "https://tarik.eu.auth0.com/"


// Inspired by: https://github.com/MoZhouqi/PhotoBrowser

struct AuthInstagram {
    
    enum Router: URLRequestConvertible {
        /// Returns a URL request or throws if an `Error` was encountered.
        ///
        /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
        ///
        /// - returns: A URL request.
        public func asURLRequest() throws -> URLRequest {            
            let (path, parameters): (String, [String: AnyObject]) = {
                switch self {
                case .popularPhotos (let userID, let accessToken):
                    let params = ["access_token": accessToken]
                    let pathString = "/v1/users/" + userID + "/media/recent"
                    return (pathString, params as [String : AnyObject])
                
                case .requestOauthCode:
                    _ = "/oauth/authorize/?client_id=" + Router.clientID + "&redirect_uri=" + Router.redirectURI + "&response_type=code"
                    return ("/photos", [:])
                }
            }()
            
            let BaeseURL = URL(string: Router.baseURLString)
            let URLRequest = Foundation.URLRequest(url: BaeseURL!.appendingPathComponent(path))
            return try Alamofire.URLEncoding.default.encode(URLRequest, with: parameters)
        }
        
        
        static let baseURLString = "https://api.instagram.com"
        static let clientID = INSTAGRAM_CLIENT_ID
        static let redirectURI = INSTAGRAM_REDIRECT_URL
        static let clientSecret = INSTAGRAM_CLIENT_SECRET
        static let authorizationURL = URL(string: Router.baseURLString + "/oauth/authorize/?client_id=" + Router.clientID + "&redirect_uri=" + Router.redirectURI + "&response_type=code")!
        
        case popularPhotos(String, String)
        case requestOauthCode
        
        static func requestAccessTokenURLStringAndParms(_ code: String) -> (URLString: String, Params: [String: AnyObject]) {
            let params = ["client_id": Router.clientID, "client_secret": Router.clientSecret, "grant_type": "authorization_code", "redirect_uri": Router.redirectURI, "code": code]
            let pathString = "/oauth/access_token"
            let urlString = AuthInstagram.Router.baseURLString + pathString
            print(urlString,params)
            return (urlString, params as [String : AnyObject])
        }
    }
    
}
