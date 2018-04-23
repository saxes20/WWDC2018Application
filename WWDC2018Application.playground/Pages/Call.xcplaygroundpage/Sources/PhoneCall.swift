//
//  PhoneCall.swift
//  
//
//  Created by Sameer Saxena on 3/31/18.
//

//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import AVFoundation

public class CallView : UIView {
    
    var sound: AVAudioPlayer?
    var butn: UIButton?
    var okButn: UIButton?
    var imageView: UIImageView?
    var imgBg: UIImageView?
    var tLbl: UILabel?
    var timeCount: Int = 0
    var timer: Timer!
    var okTime: Int = 0
    var oked: Bool = false
    var btnCnt = 0
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init () {
        
        super.init(frame: CGRect(x: 0, y: 0, width: 435, height: 630))
        self.backgroundColor = UIColor.white
        
        var cfURL = Bundle.main.url(forResource: "SF-Pro-Display-Light", withExtension: "otf")
        CTFontManagerRegisterFontsForURL(cfURL! as CFURL, CTFontManagerScope.process, nil)
        
        cfURL = Bundle.main.url(forResource: "SFCompactDisplay-Light", withExtension: "otf")
        CTFontManagerRegisterFontsForURL(cfURL! as CFURL, CTFontManagerScope.process, nil)
        
        let bg = UIImage(named: "timCall.PNG")
        imgBg = UIImageView(frame: CGRect(x: 0, y: 0, width: 435, height: 630))
        imgBg?.image = bg
        
        let date = Date()
        let calendar = Calendar.current
        var hour = calendar.component(.hour, from: date)
        var last = "AM"
        if hour > 12 {
            hour -= 12
            last = "PM"
        }
        let minuteNum = calendar.component(.minute, from: date)
        var minute = "\(minuteNum)"
        if minuteNum < 10 {
            minute = "0\(minuteNum)"
        }
        
        let timeLbl = UILabel()
        timeLbl.frame = CGRect(x: 185, y: 1.0, width: 64.0, height: 19.0)
        timeLbl.text = "\(hour):\(minute) \(last)"
        timeLbl.textColor = .white
        timeLbl.textAlignment = .center
        timeLbl.font = UIFont(name: "SFCompactDisplay-Light", size:13.0)
        
        tLbl = UILabel()
        tLbl?.frame = CGRect(x: 179, y: 97, width: 76.0, height: 22.0)
        tLbl?.text = "00:00"
        tLbl?.textColor = .white
        tLbl?.textAlignment = .center
        tLbl?.font = UIFont(name: "SFProDisplay-Light", size:18.0)
        
        let accept = UIImage(named: "acceptButton.png")
        imageView = UIImageView(image: accept)
        imageView?.frame =  CGRect(x: 284, y: 480, width: 82, height: 71)
        
        butn = UIButton(frame: CGRect(x: 284, y: 480, width: 82, height: 71))
        butn?.addTarget(self, action: #selector(CallView.click(_:)), for: UIControlEvents.touchUpInside)
        
        okButn = UIButton(frame: CGRect(x: 91, y: 139, width: 252, height: 45))
        okButn?.addTarget(self, action: #selector(CallView.acceptedMission(_:)), for: UIControlEvents.touchUpInside)
        okButn?.setTitle("OK, I CAN DO THIS", for: UIControlState.normal)
        okButn?.setTitleColor(.black, for: UIControlState.normal)
        okButn?.backgroundColor = UIColor(displayP3Red: 170/255, green: 232/255, blue: 246/255, alpha: 0.97)
        
        createSound(file: "ringtone", type: "mp3")
        playSound()
        
        self.addSubview(imgBg!)
        self.addSubview(timeLbl)
        self.addSubview(imageView!)
        self.addSubview(butn!)
        //view.addSubview(tLbl)
    }
    
    @objc func click(_ sender: UIButton) {
        btnCnt += 1
        if btnCnt == 1 {
            sound?.stop()
            let newImage = UIImage(named: "declineButton.png")
            let newBgImage = UIImage(named: "callT.PNG")
            imgBg?.image = newBgImage
            UIView.transition(with: imageView!, duration: 0.4, options: [], animations: {
                self.imageView?.transform = CGAffineTransform(rotationAngle: (3 * CGFloat.pi)/4)
            }) { (done: Bool) in
                self.imageView?.transform = CGAffineTransform(rotationAngle: 0)
                UIView.transition(with: self.imageView!,
                                  duration:0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.imageView?.image = newImage
                },
                                  completion: { (finished: Bool) in
                                    UIView.transition(with: self.imageView!, duration: 0.4, options: [], animations: {
                                        self.imageView?.frame = CGRect(x: 179, y: 480, width: 82, height: 71)
                                        self.butn?.frame = CGRect(x: 179, y: 480, width: 82, height: 71)
                                    }, completion: { (finished: Bool) in
                                        self.addSubview(self.tLbl!)
                                        if(self.timer != nil)
                                        {
                                            self.timer.invalidate()
                                        }
                                        self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(CallView.timerDidFire), userInfo: nil, repeats: true)
                                        RunLoop.current.add(self.timer, forMode: RunLoopMode.commonModes)
                                        self.createSound(file: "CallOne", type: "m4a")
                                        self.playSound()
                                    })
                                    
                })
                
            }
        }
    }
    
    func createSound(file: String, type: String) {
        let path = Bundle.main.path(forResource: file, ofType: type)!
        let url = URL(fileURLWithPath: path)
        do {
            sound = try AVAudioPlayer(contentsOf: url)
            sound?.prepareToPlay()
        } catch {
            print("Error playing sound")
        }
    }
    
    func playSound () {
        sound?.play()
    }
    
    @objc func timerDidFire()
    {
        timeCount += 1
        let minutes = timeCount / 60 % 60
        let seconds = timeCount % 60
        
        var minute = "\(minutes)"
        var second = "\(seconds)"
        if minutes < 10 {
            minute = "0\(minutes)"
        }
        if seconds < 10 {
            second = "0\(seconds)"
        }
        if seconds >= 10 {
            self.addSubview(self.okButn!)
        }
        tLbl?.text = "\(minute):\(second)"
        
        if oked {
            okTime += 1
            if okTime > 6 {
                tLbl?.isHidden = true
                imageView?.isHidden = true
                imgBg?.image = UIImage(named: "callE.PNG")
            }
        }
    }
    
    @objc func acceptedMission(_ sender: UIButton) {
        okButn?.isHidden = true
        sound?.stop()
        createSound(file: "CallTwo", type: "m4a")
        playSound()
        oked = true
    }
}

