//
//  DefaultPullToRefreshSpinnerView.swift
//  POSInfiniteScroll
//
//  Created by Ion Postolachi on 12/23/19.
//

import UIKit

final class DefaultPullToRefreshSpinnerView: UIView, PullToRefreshSpinnerViewProtocol {
    var progress: CGFloat = 0 {
        didSet {
            let oldNumberOfLines = Int(CGFloat(8) * oldValue)
            let numberOfLines = Int(CGFloat(8) * progress)
            if oldNumberOfLines > numberOfLines {
                removeLine(index: oldNumberOfLines)
            } else if numberOfLines > oldNumberOfLines {
                addLine(index: numberOfLines)
            }
        }
    }
    var isAnimating: Bool = false
    
    func startAnimating() {
        let animation = CAKeyframeAnimation(keyPath: "opacity")
        let timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        let duration: CFTimeInterval = 1.2
        
        animation.keyTimes = [0, 0.5, 1]
        animation.timingFunctions = [timingFunction, timingFunction]
        animation.values = [1, 0.1, 1]
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        let beginTime = CACurrentMediaTime()
        let beginTimes: [CFTimeInterval] = [0.12, 0.24, 0.36, 0.48, 0.6, 0.72, 0.84, 0.96]
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        for idx in 0 ..< 8 {
            let line = addLine(index: idx)
            line?.tag = idx
            animation.beginTime = beginTime + beginTimes[idx]
            line?.add(animation, forKey: "animation")
        }

        isAnimating = true
    }
    
    func stopAnimating() {
        isAnimating = false
        layer.removeAllAnimations()
        layer.sublayers?.forEach { $0.removeAllAnimations() }
    }
    
    override var frame: CGRect {
        get {
            return CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
        }
        
        set {}
    }
    
    @discardableResult
    private func addLine(index: Int) -> CustomLayer? {
        let lineSpacing: CGFloat = 2
        let defaultPadding: CGFloat = 4.0
        let sizeValue = frame.width - defaultPadding
        let center = CGPoint(x: (sizeValue / 2) + (defaultPadding / 2), y: (sizeValue/2) + (defaultPadding / 2))
        let lineSize = CGSize(width: (sizeValue - 4 * lineSpacing) / 8, height: (sizeValue - 2 * lineSpacing) / 3)
        let layers = layer.sublayers as? [CustomLayer]
        if layers?.first(where: { $0.tag == index }) != nil { return nil }
        let line = lineAt(angle: CGFloat.pi / 4 * CGFloat(index),
                          size: lineSize,
                          origin: center,
                          containerSize: CGSize(width: sizeValue, height: sizeValue),
                          color: .gray)
        line.tag = index
        layer.addSublayer(line)
        
        return line
    }
    
    private func removeLine(index: Int) {
        let layers = layer.sublayers as? [CustomLayer]
        guard let layer = layers?.first(where: { $0.tag == index }) else { return }
        layer.removeFromSuperlayer()
    }
    
    private func lineAt(angle: CGFloat, size: CGSize, origin: CGPoint, containerSize: CGSize, color: UIColor) -> CustomLayer {
        let radius = (containerSize.width / 2 - max(size.width, size.height) / 2) - 2
        let lineContainerSize = CGSize(width: max(size.width, size.height), height: max(size.width, size.height))
        let lineContainer = CustomLayer()
        let lineContainerFrame = CGRect(
            x: origin.x + radius * (cos(angle) - 0.5),
            y: origin.y + radius * (sin(angle) - 0.5),
            width: lineContainerSize.width,
            height: lineContainerSize.height)
        let line = layerWith(size: size, color: color)
        let lineFrame = CGRect(
            x: (lineContainerSize.width - size.width) / 2,
            y: (lineContainerSize.height - size.height) / 2,
            width: size.width,
            height: size.height)
        
        lineContainer.frame = lineContainerFrame
        line.frame = lineFrame
        lineContainer.addSublayer(line)
        lineContainer.sublayerTransform = CATransform3DMakeRotation((CGFloat.pi / 2) + angle, 0, 0, 1)
        
        return lineContainer
    }
    
    private func layerWith(size: CGSize, color: UIColor) -> CALayer {
        let layer = CAShapeLayer()
        var path: UIBezierPath = UIBezierPath()
        path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height),cornerRadius: size.width / 2)
        layer.fillColor = color.cgColor
        layer.backgroundColor = nil
        layer.path = path.cgPath
        layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        return layer
    }
}

private class CustomLayer: CAShapeLayer {
    var tag: Int = 0
}
