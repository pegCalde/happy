//
//  FaceView.swift
//  Happy
//
//  Created by Peggy Calderon on 07/03/2021.
//

import UIKit

protocol FaceViewDataSource: class  {
    func smilinessForFaceView(sender: FaceView) -> CGFloat?
}

@IBDesignable
class FaceView: UIView {

    weak var dataSource : FaceViewDataSource?
    
    /*VISAGE*/
    var faceCenter : CGPoint{ //centre du visage
        get{
            return convert(center, from: superview)
        }
    }
    var faceRadius : CGFloat{ //rayon du visage
        return scaling * min(bounds.size.height, bounds.size.width)/2
    }
    
    /*YEUX*/
    /*var eyeCenterR : CGPoint{
        get{
            let fromFaceCenter = convert(center, from: superview)
            return CGPoint(x: fromFaceCenter.x - 55, y: fromFaceCenter.y - 35)
        }
    }
    var eyeCenterL : CGPoint{
        get{
            let fromFaceCenter = convert(center, from: superview)
            return CGPoint(x: fromFaceCenter.x + 55, y: fromFaceCenter.y - 35)
        }
    }*/

    @IBInspectable //valeurs st modifiable (couleur du trait -> faceColor, taille du trait -> lineWidth)
    var lineWidth : CGFloat = 3{
        didSet{ //observateur d'event
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var faceColor : UIColor = UIColor.blue{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var scaling : CGFloat = 0.9{ //est utilisée dans faceRadius
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var eyesHeight : CGFloat = 0.4
    @IBInspectable var semiDistEyes : CGFloat = 0.4
    @IBInspectable var eyeRadius : CGFloat = 0.2
    @IBInspectable var mouthWidth : CGFloat = 0.4
    @IBInspectable var mouthHeigth : CGFloat = 0.4
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.*/
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        let face = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        let eyeR = CGPoint(
            x: faceCenter.x - semiDistEyes * faceRadius,
            y: faceCenter.y - eyesHeight * faceRadius)
        let drawEyeR = UIBezierPath(arcCenter: eyeR, radius: eyeRadius*faceRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        let eyeL = CGPoint(
            x: faceCenter.x - semiDistEyes * faceRadius,
            y: faceCenter.y - eyesHeight * faceRadius)
        let drawEyeL = UIBezierPath(arcCenter: eyeL, radius: eyeRadius*faceRadius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        let happiness : CGFloat? = dataSource?.smilinessForFaceView(sender: self)
        
        /*BOUCHE*/
        /*var happiness{ //distance entre les points de contrôle de la bouche => A,B,C,D
        }*/
        let A = CGPoint(
            x: faceCenter.x - mouthWidth * faceRadius,
            y: faceCenter.y + mouthHeigth * faceRadius
        )
        let B = CGPoint(
            x: faceCenter.x - mouthWidth * faceRadius/2,
            y: faceCenter.y + (mouthHeigth + happiness!/2) * faceRadius
        )
        let C = CGPoint(
            x: faceCenter.x - mouthWidth * faceRadius/2,
            y: faceCenter.y + (mouthHeigth + happiness!/2) * faceRadius
        )
        let D = CGPoint(
            x: faceCenter.x - mouthWidth * faceRadius,
            y: faceCenter.y + mouthHeigth * faceRadius
        )
        
        let mouth = UIBezierPath()
        mouth.move(to: A)
        mouth.addCurve(to: D, controlPoint1: B, controlPoint2: C)
        
        face.lineWidth = lineWidth
        drawEyeR.lineWidth = lineWidth
        drawEyeL.lineWidth = lineWidth
        mouth.lineWidth = lineWidth
        
        faceColor.set()
        
        face.stroke() //dessine le visage
        drawEyeR.stroke()
        drawEyeL.stroke()
        mouth.stroke()
    }

    @objc func scale(gesture: UIPinchGestureRecognizer){ //change la variable scaling
        scaling *= gesture.scale
        gesture.scale = 1 //max de la largeur permise par l'écran
    }
}
