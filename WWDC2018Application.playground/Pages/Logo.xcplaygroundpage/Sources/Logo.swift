//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

public class LogoView : UIView, UIGestureRecognizerDelegate {
    
    var initialTransform: CGAffineTransform?
    var gestures = Set<UIGestureRecognizer>(minimumCapacity: 3)
    
    var location = CGPoint(x: 0, y: 0)
    var isSelected: Bool = false
    var selected: UIView = UIView()
    
    public let letters: [String]
    public let numbers: [String]
    public let images: [UIImage] = [UIImage(named: "appleDotted.png")!, UIImage(named: "blackApple.png")!, UIImage(named: "grayApple.png")!, UIImage(named: "multiApple.png")!, UIImage(named: "rainbowApple.png")!, UIImage(named: "whiteApple.png")!]
    
    var views: [UIView] = []
    
    var logoView: UIImageView!
    
    var currentView: UIView!
    
    public var finalImage: UIImage
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init (characters: [String], digits: [String], font: String, size: Int, background: String) {
        
        letters = characters
        numbers = digits
        finalImage = UIImage(named: background)!
        
        super.init(frame: CGRect(x: 0, y: 0, width: 450, height: 630))
        self.backgroundColor = UIColor.white
        
        let bg = UIImage(named: "blurBack.png")
        let imgBg = UIImageView(frame: CGRect(x: -75, y: -70, width: 800, height: 800))
        imgBg.image = bg
        self.addSubview(imgBg)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        currentView = UIView(frame: CGRect(x: 0, y: 0, width: 450, height: 630))
        currentView.backgroundColor = UIColor.clear
        self.addSubview(currentView)
        
        let logoBg = UIImage(named: background)
        logoView = UIImageView(image: logoBg)
        logoView.frame = CGRect(x: -37, y: -76, width: 507, height: 452)
        currentView.addSubview(logoView)
        
        let doneButn = UIButton(frame: CGRect(x: 155, y: 384, width: 123, height: 33))
        doneButn.addTarget(self, action: #selector(LogoView.done(_:)), for: UIControlEvents.touchUpInside)
        doneButn.setTitle("DONE", for: UIControlState.normal)
        doneButn.setTitleColor(.black, for: UIControlState.normal)
        doneButn.backgroundColor = UIColor(displayP3Red: 170/255, green: 232/255, blue: 246/255, alpha: 0.53)
        currentView.addSubview(doneButn)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(LogoView.processTransform(_:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(LogoView.processTransform(_:)))
        rotate.delegate = self
        pinch.delegate = self
        currentView.addGestureRecognizer(rotate)
        currentView.addGestureRecognizer(pinch)
        
        let w = 53
        let h = 53
        
        for l in letters {
            let x = Int(arc4random_uniform(396))
            let y = Int(arc4random_uniform(140)) + 430
            let lbl = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
            lbl.text = l
            lbl.textColor = .black
            lbl.textAlignment = .center
            lbl.font = UIFont(name: font, size: CGFloat(size))
            currentView.addSubview(lbl)
            views.append(lbl)
        }
        
        for n in numbers {
            let x = Int(arc4random_uniform(396))
            let y = Int(arc4random_uniform(140)) + 430
            let lbl = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
            lbl.text = n
            lbl.textColor = .black
            lbl.textAlignment = .center
            lbl.font = UIFont(name: font, size: CGFloat(size))
            currentView.addSubview(lbl)
            views.append(lbl)
        }
        
        for i in images {
            let x = Int(arc4random_uniform(396))
            let y = Int(arc4random_uniform(140)) + 430
            let imgView = UIImageView(image: i)
            imgView.frame = CGRect(x: x, y: y, width: w, height: h)
            currentView.addSubview(imgView)
            views.append(imgView)
        }
        
    }
    
    @objc func done(_ sender: UIButton) {
        deselect(sender: selected)
        UIGraphicsBeginImageContext(currentView.frame.size)
        currentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let logo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let croppedCGImage:CGImage = (logo!.cgImage?.cropping(to: logoView.frame))!
        let croppedImage = UIImage(cgImage: croppedCGImage)
        finalImage = croppedImage
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first as UITouch?
        location = touch.location(in: currentView)
        for v in views {
            if v.frame.contains(location) && !isSelected {
                deselect(sender: selected)
                select(sender: v)
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch! = touches.first as UITouch?
        location = touch.location(in: self)
        if isSelected {
            selected.center = location
        }
        
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isSelected = false
    }
    
    func select(sender: UIView) {
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.blue.cgColor
        selected = sender
        isSelected = true
    }
    
    func deselect(sender: UIView) {
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.clear.cgColor
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func transformUsingRecognizer(_ recognizer: UIGestureRecognizer, transform: CGAffineTransform) -> CGAffineTransform {
        
        if let rotateRecognizer = recognizer as? UIRotationGestureRecognizer {
            return transform.rotated(by: rotateRecognizer.rotation)
        }
        
        if let pinchRecognizer = recognizer as? UIPinchGestureRecognizer {
            let scale = pinchRecognizer.scale
            return transform.scaledBy(x: scale, y: scale)
        }
        
        return transform
    }
    
    @objc func processTransform(_ sender: Any) {
        let gesture = sender as! UIGestureRecognizer
        switch gesture.state {
        case .began:
            if gestures.count == 0 {
                initialTransform = selected.transform
            }
            gestures.insert(gesture)
        case .changed:
            if var initial = initialTransform {
                gestures.forEach({ (gesture) in
                    initial = transformUsingRecognizer(gesture, transform: initial)
                })
                selected.transform = initial
            }
        case .ended:
            gestures.remove(gesture)
        default:
            break
        }
    }
    
}
