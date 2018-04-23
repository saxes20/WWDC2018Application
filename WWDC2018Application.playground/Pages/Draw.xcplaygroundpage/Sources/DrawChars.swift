//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import CoreML

class Canvas: UIImageView {
    
    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw(context: CGContext?, touch: UITouch) {
        let previousLocation = touch.previousLocation(in: self)
        let location = touch.location(in: self)
        let lineWidth: CGFloat = 40.0
        UIColor.black.setStroke()
        context!.setLineWidth(lineWidth)
        context!.setLineCap(.round)
        context?.move(to: previousLocation)
        context?.addLine(to: location)
        context!.strokePath()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        image?.draw(in: bounds)
        draw(context: context, touch: touch)
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func predictLetter() -> Character {
        let rawImg = createRawImg()
        let IMG_DIM: CGFloat = 28
        let scale = rawImg.size.width / IMG_DIM
        let resizedImg = resizeImage(image: rawImg, scale: scale)
        return predictImage(img: resizedImg)
    }
    
    func predictImage (img: UIImage) -> Character {
        
        let model = Characters()
        let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)
        
        let pixelArray = pixelValues(fromCGImage: img.cgImage)
        var imgArray: [Float32] = []
        for number in pixelArray! {
            imgArray.append(Float32(number)/255)
        }
        
        guard let input_data = try? MLMultiArray(shape:[784], dataType:.double) else {
            fatalError("Unexpected runtime error. MLMultiArray")
        }
        
        for (index,item) in imgArray.enumerated() {
            input_data[index] = NSNumber(value: item)
        }
        
        guard let throw_output = try? MLMultiArray(shape:[27], dataType:.double) else {
            fatalError("Unexpected runtime error. MLMultiArray")
        }
        
        guard let prediction = try? model.prediction(input1: input_data) else { return Character("") }
        
        prediction.output1
        
        var predictOutputs: [Double] = []
        for indx in 0...(prediction.output1.count-1) {
            predictOutputs.append(Double(truncating: prediction.output1[indx]))
        }
        
        let max = predictOutputs.max()
        let maxInd = predictOutputs.index(of: max!)
        
        predictOutputs.remove(at: maxInd!)
        let secMax = predictOutputs.max()
        let secInd = predictOutputs.index(of: secMax!)
        alphabet[secInd!-1]
        //print(alphabet[secInd!-1])
        
        return alphabet[maxInd!-1]
        
        
    }
    
    func pixelValues(fromCGImage imageRef: CGImage?) -> [UInt8]?
    {
        var width = 0
        var height = 0
        var pixelValues: [UInt8]?
        if let imageRef = imageRef {
            width = imageRef.width
            height = imageRef.height
            let bitsPerComponent = imageRef.bitsPerComponent
            let bytesPerRow = width
            let totalBytes = height * bytesPerRow
            
            let colorSpace = CGColorSpaceCreateDeviceGray()
            var intensities = [UInt8](repeating: 0, count: totalBytes)
            
            let contextRef = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: 0)
            contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
            
            pixelValues = intensities
        }
        
        return pixelValues
    }
    
    func createRawImg () -> UIImage {
        
        UIGraphicsBeginImageContext((frame.size))
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let sourceImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let subImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 365, height: 365))
        self.addSubview(subImg)
        
        let startImg = CIImage(image: sourceImage!)
        if let filter = CIFilter(name: "CIColorInvert") {
            filter.setValue(startImg, forKey: kCIInputImageKey)
            let endImg = UIImage(ciImage: filter.outputImage!)
            subImg.image = endImg
            subImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            print("Sent image")
        }
        
        UIGraphicsBeginImageContext((self.frame.size))
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        var finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        finalImage = flipImageLeftRight(finalImage!)
        
        subImg.image = sourceImage
        subImg.transform = CGAffineTransform(rotationAngle: 0)
        
        return finalImage!
    }
    
    func flipImageLeftRight(_ image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width, y: image.size.height)
        context.scaleBy(x: -image.scale, y: -image.scale)
        context.draw(image.cgImage!, in: CGRect(origin:CGPoint.zero, size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeImage(image: UIImage, scale: CGFloat) -> UIImage {
        let width = image.size.width / scale
        let height = image.size.height / scale
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image.draw(in: CGRect(x: 0, y: 0,width: width, height: height))
        let final = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return final!
    }
    
    
}

public class DrawView: UIView {
    
    public var letters: String = ""
    public var font: String = "HelveticaNeue-Light"
    public var size: Int = 33
    
    var subView: Canvas
    
    var checkButn: UIButton!
    var predictionLabel: UILabel!
    
    var acceptButton: UIButton!
    var declineButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView!
    
    public init() {
        //Added checkButn
        //Created checkImg function in DrawView and predictLetter function in Canvas
        
        subView = Canvas(x: 36, y: 38, width: 365, height: 365)
        
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 450, height: 630))
        self.backgroundColor = UIColor.white
        
        let bgImage = UIImage(named: "wwdc15.png")
        let bg = UIImageView(image: bgImage)
        bg.frame = CGRect(x: -50, y: -12, width: 749, height: 683)
        self.addSubview(bg)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        checkButn = UIButton(frame: CGRect(x: 117, y: 433, width: 202, height: 49))
        checkButn.addTarget(self, action: #selector(DrawView.checkImg(_:)), for: UIControlEvents.touchUpInside)
        checkButn.setTitle("CHECK", for: UIControlState.normal)
        checkButn.setTitleColor(.black, for: UIControlState.normal)
        checkButn.titleLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 28)
        checkButn.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.65)
        self.addSubview(checkButn)
        
        let checkView = UIView(frame: CGRect(x: 142, y: 508, width: 152, height: 72))
        checkView.backgroundColor = UIColor.white
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.frame = CGRect(x: 66, y: 26, width: 20, height: 20)
        checkView.addSubview(activityIndicator)
        
        predictionLabel = UILabel(frame: CGRect(x: 61, y: 17, width: 30, height: 39))
        predictionLabel.text = ""
        predictionLabel.textAlignment = .center
        predictionLabel.textColor = .black
        predictionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 33)
        checkView.addSubview(predictionLabel)
        
        acceptButton = UIButton(type: .custom)
        acceptButton.frame = CGRect(x: 321, y: 525, width: 39, height: 39)
        acceptButton.setImage(UIImage(named: "greenCircle.png"), for: .normal)
        acceptButton.addTarget(self, action: #selector(DrawView.accept(_:)), for: .touchUpInside)
        acceptButton.isUserInteractionEnabled = false
        
        declineButton = UIButton(type: .custom)
        declineButton.frame = CGRect(x: 78, y: 529, width: 35, height: 35)
        declineButton.setImage(UIImage(named: "redCircle.png"), for: .normal)
        declineButton.addTarget(self, action: #selector(DrawView.deny(_:)), for: .touchUpInside)
        declineButton.isUserInteractionEnabled = false
        
        self.addSubview(acceptButton)
        self.addSubview(declineButton)
        
        self.addSubview(subView)
        self.addSubview(checkView)
    }
    
    @objc func checkImg (_ sender: UIButton) {
        checkButn.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        delay (0.01) {
            let prediction = self.subView.predictLetter()
            self.predictionLabel.text = "\(prediction)"
            self.acceptButton.isUserInteractionEnabled = true
            self.declineButton.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc func accept (_ sender: UIButton) {
        print("Accepted")
        letters += predictionLabel.text!
        letters += " "
        PlaygroundPage.current.keyValueStore["letters"] = .string(letters)
        reset()
    }
    
    @objc func deny (_ sender: UIButton) {
        print("Denied")
        reset()
    }
    
    func reset() {
        subView.removeFromSuperview()
        subView = Canvas(x: 36, y: 38, width: 365, height: 365)
        checkButn.isUserInteractionEnabled = true
        self.addSubview(subView)
        predictionLabel.text = ""
        self.acceptButton.isUserInteractionEnabled = false
        self.declineButton.isUserInteractionEnabled = false
    }
    
    public func setFont(name: String, size: CGFloat) {
        predictionLabel.font = UIFont(name: name, size: size)
        font = name
        self.size = Int(size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
