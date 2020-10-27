//
//  ViewController.swift
//  OnePlusBootAnimation
//
//  Created by Vineet Kumar on 20/08/20.
//  Copyright © 2020 Vineet Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var layerBox = CAShapeLayer()
    var layerPlusHorizontal = CAShapeLayer()
    var layerPlusVertical = CAShapeLayer()
    var layerOne = CAShapeLayer()
    var layerInnnerCircle = CAShapeLayer()
    var boxView : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLogoView()
    }
    
    private func setupLogoView() {
        
        let boxView = UIView()
        boxView.translatesAutoresizingMaskIntoConstraints = false
        boxView.backgroundColor = .clear
        view.addSubview(boxView)
        self.boxView = boxView
        
        NSLayoutConstraint.activate([
            boxView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            boxView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            boxView.widthAnchor.constraint(equalToConstant: 50),
            boxView.heightAnchor.constraint(equalToConstant: 50)])
        
        view.layoutIfNeeded()
        createSquare()
        createOne()
        createPlus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animatePlus()
        }
    }
    
    fileprivate func addPathToLayer(_ path: CGMutablePath, _ outerlayer: inout CAShapeLayer) {
        
        let layer = CAShapeLayer()
        layer.path = path
        layer.lineWidth = 6.0
        layer.strokeColor = UIColor.white.cgColor
        layer.frame = boxView.bounds
        boxView.layer.addSublayer(layer)
        outerlayer = layer
    }
    
    fileprivate func createSquare() {
    
        let path = CGMutablePath()
        let maxX = boxView.bounds.maxX
        let minX = boxView.bounds.minX
        let midX = boxView.bounds.midX
        let midY = boxView.bounds.midY
        let maxY = boxView.bounds.maxY
        let minY = boxView.bounds.minY
        path.move(to: CGPoint(x: midX + 8.0, y: minY))
        path.addLine(to: CGPoint(x: minX, y: minY))
        path.addLine(to: CGPoint(x: minX, y: maxY))
        path.addLine(to: CGPoint(x: maxX, y: maxY))
        path.addLine(to: CGPoint(x: maxX, y: midY - 8.0))
        
        addPathToLayer(path, &layerBox)
    }

    fileprivate func createOne() {
        
        let path = CGMutablePath()
        let midX = boxView.bounds.midX
        let maxY = boxView.bounds.maxY
        let minY = boxView.bounds.minY
        let space : CGFloat = 15.0
        let length : CGFloat = 8.0
        path.move(to: CGPoint(x: midX - length, y: minY + space))
        path.addLine(to: CGPoint(x: midX, y: minY + space))
        path.addLine(to: CGPoint(x: midX, y: maxY - space))
        path.addLine(to: CGPoint(x: midX - length, y: maxY - space))
        path.addLine(to: CGPoint(x: midX + length, y: maxY - space))
        
        addPathToLayer(path, &layerOne)
    }
    
    fileprivate func createPlus() {
        
        let maxX = boxView.bounds.maxX
        let minY = boxView.bounds.minY
        let length : CGFloat = 10.0
        let path1 = CGMutablePath()
        path1.move(to: CGPoint(x: maxX, y: minY - length))
        path1.addLine(to: CGPoint(x: maxX, y: minY + length))
        
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: maxX + length, y: minY))
        path2.addLine(to: CGPoint(x: maxX - length, y: minY))
        
        addPathToLayer(path1, &layerPlusVertical)
        addPathToLayer(path2, &layerPlusHorizontal)
    }

    fileprivate func innerPlusPath() -> (h: CGPath, v: CGPath) {
        
        let maxX = boxView.bounds.maxX
        let minY = boxView.bounds.minY
        let length : CGFloat = 18.0
        let plusLength : CGFloat = 10.0
        let path1 = CGMutablePath()
        path1.move(to: CGPoint(x: maxX + plusLength, y: minY))
        path1.addLine(to: CGPoint(x: maxX - length, y: minY))
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: maxX, y: minY - plusLength))
        path2.addLine(to: CGPoint(x: maxX, y: minY + length))
        
        return (path1, path2)
    }
    
    fileprivate func outerPlusPath() -> (h: CGPath, v: CGPath) {
        
        let maxX = boxView.bounds.maxX
        let minY = boxView.bounds.minY
        let length : CGFloat = 18.0
        let path1 = CGMutablePath()
        path1.move(to: CGPoint(x: maxX + 3, y: minY))
        path1.addLine(to: CGPoint(x: maxX - length, y: minY))
        let path2 = CGMutablePath()
        path2.move(to: CGPoint(x: maxX, y: minY - 3))
        path2.addLine(to: CGPoint(x: maxX, y: minY + length))
        
        return (path1, path2)
    }
    
    fileprivate func animatePlus() {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.33)
        let animation1 : CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation1.toValue = self.innerPlusPath().h
        animation1.fillMode = .forwards
        animation1.isRemovedOnCompletion = false
        let animation2 : CABasicAnimation = CABasicAnimation(keyPath: "path")
        animation2.toValue = self.innerPlusPath().v
        animation2.fillMode = .forwards
        animation2.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.33)
            let animation1 : CABasicAnimation = CABasicAnimation(keyPath: "path")
            animation1.toValue = self.outerPlusPath().h
            animation1.fillMode = .forwards
            animation1.isRemovedOnCompletion = false
            let animation2 : CABasicAnimation = CABasicAnimation(keyPath: "path")
            animation2.toValue = self.outerPlusPath().v
            animation2.fillMode = .forwards
            animation2.isRemovedOnCompletion = false
            
            CATransaction.setCompletionBlock {
                self.animateBox()
            }
            
            self.layerPlusHorizontal.add(animation1, forKey: nil)
            self.layerPlusVertical.add(animation2, forKey: nil)
            CATransaction.commit()
        }
        
        self.layerPlusHorizontal.add(animation1, forKey: nil)
        self.layerPlusVertical.add(animation2, forKey: nil)
        CATransaction.commit()
    }
    
    fileprivate func drawCircle() -> CGPath {
        
        let path = UIBezierPath()
        let center = CGPoint(x: boxView.bounds.width/2, y: boxView.bounds.height/2)
        let radius = boxView.bounds.width / 2
        path.addArc(withCenter: center, radius: radius, startAngle: -CGFloat.pi, endAngle: -CGFloat.pi / 2, clockwise: true)
        path.addArc(withCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 0, clockwise: true)
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        path.addArc(withCenter: center, radius: radius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi, clockwise: true)
        path.close()
        
        return path.cgPath
    }
    
    fileprivate func drawSquare() -> CGPath {
        
        let path = UIBezierPath()
        let side = boxView.bounds.maxX
        let startX = boxView.bounds.width/2 - side / 2
        let startY = boxView.bounds.height/2 - side / 2
        path.move(to: CGPoint(x: startX, y: startY))
        path.addLine(to: path.currentPoint)
        path.addLine(to: CGPoint(x: startX + side, y: startY))
        path.addLine(to: path.currentPoint)
        path.addLine(to: CGPoint(x: startX + side, y: startY + side))
        path.addLine(to: path.currentPoint)
        path.addLine(to: CGPoint(x: startX, y: startY + side))
        path.addLine(to: path.currentPoint)
        path.close()
        
        return path.cgPath
    }
    
    fileprivate func animateBox() {
        
        layerPlusHorizontal.removeFromSuperlayer()
        layerPlusVertical.removeFromSuperlayer()

        layerBox.path = drawSquare()
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        let boxAnimation = CABasicAnimation(keyPath: "path")
        boxAnimation.toValue = drawCircle()
        let sizeAnimation = CABasicAnimation(keyPath: "transform")
        sizeAnimation.toValue = CATransform3DMakeScale(0.4, 0.4, 1)
        let widthAnimation = CABasicAnimation(keyPath: "lineWidth")
        widthAnimation.toValue = 12.0

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [boxAnimation, sizeAnimation, widthAnimation]
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false
        
        layerBox.add(groupAnimation, forKey: nil)
        
        let oneSizeAnimation = CABasicAnimation(keyPath: "transform")
        oneSizeAnimation.toValue = CATransform3DMakeScale(0.0, 0.0, 1)
        let oneOpacityAnimation = CABasicAnimation(keyPath: "opacity")
        oneOpacityAnimation.toValue = 0.0
        
        let oneGroupAnimation = CAAnimationGroup()
        oneGroupAnimation.animations = [oneSizeAnimation, oneOpacityAnimation]
        oneGroupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        oneGroupAnimation.fillMode = .forwards
        oneGroupAnimation.isRemovedOnCompletion = false
        
        layerOne.add(oneGroupAnimation, forKey: nil)
        CATransaction.commit()
        
        let redCircleLayer = CAShapeLayer()
        redCircleLayer.path = drawCircle()
        redCircleLayer.fillColor = UIColor.red.cgColor
        redCircleLayer.frame = boxView.bounds
        redCircleLayer.transform = CATransform3DMakeScale(0.0, 0.0, 1)
        boxView.layer.addSublayer(redCircleLayer)
        layerInnnerCircle = redCircleLayer
        
        CATransaction.begin()
        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.toValue = CATransform3DMakeScale(0.3, 0.3, 1)
        scaleAnimation.beginTime = CACurrentMediaTime() + 0.33
        scaleAnimation.duration = 1.0
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        CATransaction.setCompletionBlock {
            self.circleAnimation()
        }
        
        redCircleLayer.add(scaleAnimation, forKey: nil)
        CATransaction.commit()
    }
    
    fileprivate func circleAnimation() {
        
        CATransaction.begin()
        let innerCircleAnimation = CABasicAnimation(keyPath: "transform")
        innerCircleAnimation.toValue = CATransform3DMakeScale(0.45, 0.45, 1)
        innerCircleAnimation.duration = 0.5
        innerCircleAnimation.fillMode = .forwards
        innerCircleAnimation.isRemovedOnCompletion = false
        innerCircleAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        let outerCircleAnimation = CABasicAnimation(keyPath: "transform")
        outerCircleAnimation.toValue = CATransform3DMakeScale(0.2, 0.2, 1)
        outerCircleAnimation.duration = 1.0
        outerCircleAnimation.fillMode = .forwards
        outerCircleAnimation.isRemovedOnCompletion = false
        outerCircleAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        CATransaction.setCompletionBlock {
            self.layerBox.fillColor = UIColor.white.cgColor
            self.circlesRotate()
        }
        
        layerInnnerCircle.add(innerCircleAnimation, forKey: nil)
        layerBox.add(outerCircleAnimation, forKey: nil)
        CATransaction.commit()
    }
    
    fileprivate func circlesRotate() {
        
        CATransaction.begin()
        let translateAnimation = CABasicAnimation(keyPath: "transform.translation.y")
        let translation : CGFloat = 40
        translateAnimation.toValue = -translation
        translateAnimation.duration = 1.0
        translateAnimation.fillMode = .forwards
        translateAnimation.isRemovedOnCompletion = false
        translateAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        CATransaction.setCompletionBlock {
            
            let circlePath = UIBezierPath.init(arcCenter: CGPoint(x: self.boxView.bounds.midX, y: self.boxView.bounds.midY + translation), radius: 40, startAngle: -CGFloat.pi / 2, endAngle: ((CGFloat.pi * 2) - (CGFloat.pi / 2)), clockwise: true)
            
            let replicatorLayer = CAReplicatorLayer()
            replicatorLayer.addSublayer(self.layerBox)
            
            let animation = CAKeyframeAnimation(keyPath: "position")
            animation.duration = 1.5
            animation.repeatCount = 4
            animation.path = circlePath.cgPath
            animation.calculationMode = .cubic
            animation.fillMode = .forwards
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.isRemovedOnCompletion = false
               
            self.layerBox.add(animation, forKey: nil)
            
            replicatorLayer.instanceDelay = 0.9
            replicatorLayer.instanceCount = 2
            
            self.boxView.layer.insertSublayer(replicatorLayer, below: self.layerInnnerCircle)
        
            DispatchQueue.main.asyncAfter(deadline: .now() +  ((1.5 * 4) + 0.9)) {
                self.dropCircleAnimation(replicatorLayer)
            }
        }
        
        layerBox.add(translateAnimation, forKey: nil)
        CATransaction.commit()
    }
    
    @objc fileprivate func dropCircleAnimation(_ layer: CAReplicatorLayer) {
        
        layer.removeFromSuperlayer()

        let path = CGMutablePath()
        path.move(to: CGPoint(x: boxView.bounds.midX, y: -15))
        path.addLine(to: CGPoint(x: boxView.bounds.midX, y: 15))

        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.strokeEnd = 0 // Initial stroke to zero
        shapeLayer.lineWidth = 11.0
        shapeLayer.lineCap = .round
        shapeLayer.path = path
        shapeLayer.frame = boxView.bounds
        boxView.layer.addSublayer(shapeLayer)

        CATransaction.begin()
        let strokeAnim = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnim.duration = 0.33
        strokeAnim.fromValue = 0
        strokeAnim.toValue = 1
        strokeAnim.fillMode = .forwards
        strokeAnim.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            
            let widthAnim = CABasicAnimation(keyPath: "lineWidth")
            widthAnim.toValue = 0.0
            
            let path = CGMutablePath()
            path.move(to: CGPoint(x: self.boxView.bounds.midX, y: 15))
            path.addLine(to: CGPoint(x: self.boxView.bounds.midX, y: self.boxView.bounds.midY))
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.toValue = path
    
            let groupAnim = CAAnimationGroup()
            groupAnim.animations = [widthAnim, pathAnimation]
            groupAnim.duration = 0.33
            groupAnim.fillMode = .forwards
            groupAnim.timingFunction = CAMediaTimingFunction(name: .easeOut)
            groupAnim.isRemovedOnCompletion = false
            shapeLayer.add(groupAnim, forKey: nil)
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.boxView.bounds.midX, y: 15), radius: CGFloat(5), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
            let circleLayer = CAShapeLayer()
            circleLayer.fillColor = UIColor.white.cgColor
            circleLayer.path = circlePath
            circleLayer.frame = self.boxView.bounds
            self.boxView.layer.addSublayer(circleLayer)
            
            let pathAnim = CABasicAnimation(keyPath: "transform.translation.y")
            pathAnim.toValue = 10
            pathAnim.duration = 0.33
            pathAnim.fillMode = .forwards
            pathAnim.timingFunction = CAMediaTimingFunction(name: .easeOut)
            pathAnim.isRemovedOnCompletion = false
            
            circleLayer.add(pathAnim, forKey: nil)
            self.layerBox = circleLayer
            
            self.finalAnimation()
        }
        
        shapeLayer.add(strokeAnim, forKey: nil)
        CATransaction.commit()
    }
    
    fileprivate func finalAnimation() {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        let path = UIBezierPath(arcCenter: CGPoint(x: self.boxView.bounds.midX, y: 15), radius: CGFloat(13), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        
        let circleAnimation = CABasicAnimation(keyPath: "path")
        circleAnimation.toValue = path
        circleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        circleAnimation.fillMode = .forwards
        circleAnimation.isRemovedOnCompletion = false
        
        layerBox.add(circleAnimation, forKey: nil)
        
        let innerRedLayer = CAShapeLayer()
        innerRedLayer.path = UIBezierPath(arcCenter: CGPoint(x: self.boxView.bounds.midX, y: self.boxView.bounds.midY), radius: CGFloat(13), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        innerRedLayer.fillColor = UIColor.red.cgColor
        innerRedLayer.frame = boxView.bounds
        innerRedLayer.transform = CATransform3DMakeScale(0.0, 0.0, 1)
        boxView.layer.insertSublayer(innerRedLayer, above: layerBox)
        
        let innerScaleAnim = CABasicAnimation(keyPath: "transform")
        innerScaleAnim.toValue = CATransform3DMakeScale(0.5, 0.5, 1)
        innerScaleAnim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        innerScaleAnim.fillMode = .forwards
        innerScaleAnim.isRemovedOnCompletion = false
        
        innerRedLayer.add(innerScaleAnim, forKey: nil)
        CATransaction.commit()
        
        CATransaction.begin()
        let boxAnimation = CABasicAnimation(keyPath: "path")
        boxAnimation.toValue = drawSquare()
        let sizeAnimation = CABasicAnimation(keyPath: "transform")
        sizeAnimation.toValue = CATransform3DMakeScale(1, 1, 1)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [boxAnimation, sizeAnimation]
        groupAnimation.duration = 1.0
        groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            self.reboot()
        }
        
        layerInnnerCircle.add(groupAnimation, forKey: nil)
        CATransaction.commit()
    }
    
    fileprivate func reboot() {
        
        let rebootButton = UIButton(frame: CGRect(origin: CGPoint(x: view.bounds.midX - 24, y: view.bounds.midY + 100), size: CGSize(width: 48, height: 48)))
        rebootButton.setImage(UIImage.init(systemName: "arrow.clockwise"), for: .normal)
        rebootButton.addTarget(self, action: #selector(rebootBtnTap), for: .touchUpInside)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view.addSubview(rebootButton)
        }
    }
    
    @objc fileprivate func rebootBtnTap(_ btn: UIButton) {
        
        btn.removeFromSuperview()
    
        let opacityAnim = CABasicAnimation(keyPath: "opacity")
        opacityAnim.toValue = 0.0
        opacityAnim.duration = 1.0
        opacityAnim.fillMode = .forwards
        opacityAnim.isRemovedOnCompletion = false
        self.boxView.layer.add(opacityAnim, forKey: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.boxView.removeFromSuperview()
            self.setupLogoView()
        }
    }
}
