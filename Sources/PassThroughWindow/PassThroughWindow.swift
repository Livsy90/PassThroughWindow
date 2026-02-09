import UIKit

public final class PassThroughWindow: UIWindow {
    private var handledEvents = Set<UIEvent>()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    @available(iOS 13.0, *)
    public override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override final func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let rootViewController, let rootView = rootViewController.view else { return nil }
        
        guard let event else {
            return super.hitTest(point, with: nil)
        }
        
        guard let hitView = super.hitTest(point, with: event) else {
            handledEvents.removeAll()
            return nil
        }
        
        if handledEvents.contains(event) {
            handledEvents.removeAll()
            return hitView
        } else if #available(iOS 26, *) {
            handledEvents.insert(event)
            let name = rootView.layer.hitTest(point)?.name
            if name == nil {
                return hitView
            } else if name?.starts(with: "@") == true {
                if let realHit = deepestHitView(in: rootView, at: point, with: event) {
                    if realHit === rootView {
                        return nil
                    } else {
                        return realHit
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else if #available(iOS 18, *) {
            handledEvents.insert(event)
            return hitView
        } else {
            return hitView
        }
    }
    
    private func deepestHitView(in root: UIView, at point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !root.isHidden, root.alpha > 0.01, root.isUserInteractionEnabled else { return nil }

        for subview in root.subviews.reversed() {
            let pointInSubview = subview.convert(point, from: root)
            if let hit = deepestHitView(in: subview, at: pointInSubview, with: event) {
                return hit
            }
        }
        
        return root.point(inside: point, with: event) ? root : nil
    }
}

