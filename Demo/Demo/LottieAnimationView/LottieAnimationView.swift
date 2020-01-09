import Foundation
import Lottie
import POSInfiniteScroll

final class LottieAnimationView: UIView, PullToRefreshSpinnerViewProtocol {
    
    private let animationView: AnimationView
    
    var isAnimating: Bool {
        return animationView.isAnimationPlaying
    }
    
    var progress: CGFloat {
        get {
            return animationView.currentProgress
        }
        
        set {
            animationView.currentProgress = newValue
        }
    }

    override init(frame: CGRect) {
        animationView = AnimationView()
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        animationView = AnimationView()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let animation = Animation.named("1129-loader-spinner")
        animationView.animation = animation
        animationView.loopMode = .loop
        addSubview(animationView)
    }
    
    override var frame: CGRect {
        didSet {
            animationView.frame.size = frame.size
        }
    }
    
    func startAnimating() {
        animationView.play()
    }
    
    func stopAnimating() {
        animationView.stop()
    }
}
