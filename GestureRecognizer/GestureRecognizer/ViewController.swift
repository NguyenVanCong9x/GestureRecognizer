//
//  ViewController.swift
//  GestureRecognizer
//
//  Created by Nguyen Van Cong on 12/29/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint (
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        
        gesture.setTranslation(.zero, in: view)
//        Bạn có thể tìm thấy trạng thái hiện tại của trình nhận dạng cử chỉ bằng cách xem thuộc tính của nó (state)
        guard gesture.state == .ended else {
            return
        }
//        1 Tính độ dài của vectơ vận tốc (tức là độ lớn).
        let velocity = gesture.velocity(in: view)
        let magnitude = sqrt((velocity.x * velocity.y) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200
//        2 Giảm tốc độ nếu độ dài <200. Ngược lại, tốc độ sẽ tăng.
        let slideFactor = slideMultiplier * 0.1
//        3 Tính toán điểm cuối cùng dựa trên velocity và slideFactor.
        var finalPoint = CGPoint (
            x: gestureView.center.x + (velocity.x * slideFactor),
            y: gestureView.center.y + (velocity.y * slideFactor)
        )
//        4 Đảm bảo rằng điểm cuối cùng nằm trong giới hạn của chế độ xem
        finalPoint.x = min(max(finalPoint.x, 0), view.bounds.width)
        finalPoint.y = min(max(finalPoint.y, 0), view.bounds.height)
//        5 Animates the view to the final resting place.
        UIView.animate(withDuration: Double(slideFactor * 2), delay: 0,
//        6 Uses the ease out animation option to slow the movement over time
                       options: .curveEaseOut, animations: {
            gestureView.center = finalPoint
        }, completion: nil)
        
    }
    private let size: CGFloat = 200
    @IBAction func hanPinch(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }

        gestureView.transform = gestureView.transform.scaledBy(
          x: gesture.scale,
          y: gesture.scale
        )
        gesture.scale = 1
        
    }
    
    @IBAction func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }

        gestureView.transform = gestureView.transform.rotated(
          by: gesture.rotation
        )
        gesture.rotation = 0
    }
}
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

