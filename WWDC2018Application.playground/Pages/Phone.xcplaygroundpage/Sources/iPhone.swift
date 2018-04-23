//
//  iPhone.swift
//  
//
//  Created by Sameer Saxena on 3/31/18.
//

import UIKit
import PlaygroundSupport
import AVFoundation

public class iPhoneView : UIView {
    
    var count = 0
    var sound: AVAudioPlayer?
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 435, height: 630))
        self.backgroundColor = UIColor.white
        
        let cfURL = Bundle.main.url(forResource: "SF-Pro-Display-Thin", withExtension: "otf")
        CTFontManagerRegisterFontsForURL(cfURL! as CFURL, CTFontManagerScope.process, nil)
        
        let bg = UIImage(named: "bg2.jpeg")
        let imgBg = UIImageView(image: bg)
        imgBg.frame = CGRect(x: 0, y: 0, width: 435, height: 630)
        
        let subLbl = UILabel()
        subLbl.frame = CGRect(x: 142, y: 574, width: 166.0, height: 21.0)
        subLbl.text = "Tap screen to unlock"
        subLbl.textColor = .white
        subLbl.font = UIFont(name: "HelveticaNeue-Medium", size:16.0)
        subLbl.textAlignment = .center
        
        let date = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date)
        if hour > 12 {
            hour -= 12
        }
        let minuteNum = calendar.component(.minute, from: date)
        var minute = "\(minuteNum)"
        if minuteNum < 10 {
            minute = "0\(minuteNum)"
        }
        
        let timeLbl = UILabel()
        timeLbl.frame = CGRect(x: 111, y: 70.0, width: 212.0, height: 84.0)
        timeLbl.text = "\(hour):\(minute)"
        timeLbl.textColor = .white
        timeLbl.textAlignment = .center
        timeLbl.font = UIFont(name: "SFProDisplay-Thin", size:74.0)
        
        let dateLbl = UILabel()
        dateLbl.frame = CGRect(x: 144, y: 153.0, width: 152.0, height: 21.0)
        dateLbl.text = "Sunday, June 3"
        dateLbl.textColor = .white
        dateLbl.textAlignment = .center
        dateLbl.font = UIFont(name: "HelveticaNeue", size:19.0)
        
        self.addSubview(imgBg)
        
        self.addSubview(subLbl)
        self.addSubview(timeLbl)
        self.addSubview(dateLbl)
    }
    
    public func presentNotification() {
        let noti = UIImage(named: "notification.png")
        let notification = UIImageView(image: noti)
        let startFrame = CGRect(x: 187, y: 210, width: 101, height: 21)
        let finalFrame = CGRect(x: 19, y: 205, width: 402, height: 82)
        notification.frame = startFrame
        self.addSubview(notification)
        createSound(file: "iphone_notification", type: "mp3")
        playSound()
        UIView.animate(withDuration: 0.25) {
            notification.frame = finalFrame
        }
    }
    
    public func createSound(file: String, type: String) {
        let path = Bundle.main.path(forResource: file, ofType: type)!
        let url = URL(fileURLWithPath: path)
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            sound?.prepareToPlay()
        } catch {
            print("Error playing sound")
        }
    }
    
    public func playSound () {
        sound?.play()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        count += 1
        if count == 1 { presentNotification() }
        else if count == 2 { print("hello" )}
    }
}

