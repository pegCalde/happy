//
//  happinessViewController.swift
//  Happy
//
//  Created by Peggy Calderon on 07/03/2021.
//

import UIKit

class happinessViewController: UIViewController, FaceViewDataSource {
    
    func smilinessForFaceView(sender: FaceView) -> CGFloat? {
        return CGFloat(happy - 50) / 50
    }
    

    
    var happy : Int = 75{ // montre une bouche entre 0 (pas content) et 100(hyper content)
        didSet{
            happy = min(max(happy, 0), 100)
            print("allegresse = \(happy)")
            updateUI()
        }
    }
    
    func updateUI() {
        faceView.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var faceView: FaceView! {
        didSet{
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector (faceView.scale(gesture: ))))
            faceView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.changeHappiness(gesture: ))))
        }
    }
    
    @objc func changeHappiness(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .changed : fallthrough
        case .ended : happy += Int(gesture.translation(in: faceView).y/6)
        default:
            break
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
