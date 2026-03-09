final class PassThroughWindow: UIWindow {
    private var handledEvenets = Set<UIEvent>()

    override final func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let rootViewController, let rootView = rootViewController.view else { return nil }

        guard let event else {
            return super.hitTest(point, with: nil)
        }

        guard let hitView = super.hitTest(point, with: event) else {
            handledEvenets.removeAll()
            return nil
        }
        if handledEvenets.contains(event) {
            handledEvenets.removeAll()
            return hitView
        } else if #available(iOS 26, *) {
            let layerName = rootView.layer.hitTest(point)?.name
            if layerName == nil || layerName?.hasPrefix("@") == true {
                handledEvenets.insert(event)
                return hitView
            }
            return hitView == rootView ? nil : hitView
        } else if hitView == rootView {
            return nil
        } else if #available(iOS 18, *) {
            handledEvenets.insert(event)
            return hitView
        } else {
            return hitView
        }
    }
}
