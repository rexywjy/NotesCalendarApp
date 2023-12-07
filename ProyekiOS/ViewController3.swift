//
//  ViewController3.swift
//  ProyekiOS
//
//  Created by Patrick Giovanno on 07/12/23.
//

import UIKit
import PencilKit
import PhotosUI

class ViewController3: UIViewController, PKCanvasViewDelegate {
    
    var finger = UIBarButtonItem(title: "Finger", style: .plain, target: self, action: #selector(fingerTap))
    var save = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTap))
    
    let canvasWidth: CGFloat = UIScreen.main.bounds.width
    let canvasOverscrollHeight: CGFloat = UIScreen.main.bounds.height
    var drawing = PKDrawing()
    let toolPicker = PKToolPicker.init()

    @IBOutlet weak var canvasView: PKCanvasView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItems = [finger, save]
        
        canvasView.delegate = self
        canvasView.drawing = drawing
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toolPicker.addObserver(canvasView)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.isRulerActive = false
        canvasView.isOpaque = true
        canvasView.drawingPolicy = .anyInput
        canvasView.becomeFirstResponder()
    }
    
    func updateContentSizeForDrawing() {
        let drawing = canvasView.drawing
        let contentHeight: CGFloat
        if !drawing.bounds.isNull {
            contentHeight = max(canvasView.bounds.height, (drawing.bounds.maxY + self.canvasOverscrollHeight) * canvasView.zoomScale)
        } else {
            contentHeight = canvasView.bounds.height
        }
        canvasView.contentSize = CGSize(width: canvasWidth * canvasView.zoomScale, height: contentHeight)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let canvasScale = canvasView.bounds.width / canvasWidth
        canvasView.minimumZoomScale = canvasScale
        canvasView.maximumZoomScale = canvasScale
        canvasView.zoomScale = canvasScale
        updateContentSizeForDrawing()
        canvasView.contentOffset = CGPoint(x: 0, y: -canvasView.adjustedContentInset.top)
    }

    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    @objc func fingerTap() {
        if canvasView.drawingPolicy == .anyInput {
            canvasView.drawingPolicy = .pencilOnly
        } else {
            canvasView.drawingPolicy = .anyInput
        }
        finger.title = canvasView.drawingPolicy != .pencilOnly ? "Finger" : "Pencil"
    }
    
    @objc func saveTap() {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if image != nil {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image!)
            }, completionHandler: { success, error in
                print("done saving to camera roll")
                let alertController = UIAlertController(title: "DONE!", message: "Saved to Camera Roll", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                DispatchQueue.main.async {
                    self.present(alertController, animated: true)
                }

            })
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
