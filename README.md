# PassThroughWindow

`PassThroughWindow` is a custom `UIWindow` subclass designed for overlay UI that must remain visible and interactive **without blocking the rest of the app**.

It is especially useful for global UI elements such as toasts, banners, floating panels, or debug overlays that live in their own window but should allow all unrelated gestures to pass through to the underlying application.

---

## Why PassThroughWindow Exists

Placing UI in a separate `UIWindow` is a common technique for global overlays. However, a top-level window easily becomes a gesture sink:

- Scroll views underneath stop scrolling
- Buttons beneath the overlay stop responding
- The app feels partially frozen even though the overlay is visually small

This happens because UIKit always hit-tests the topmost window first.

`PassThroughWindow` fixes this by selectively opting out of event handling when a touch does not target an actual interactive view inside the overlay.

---

## Key Behavior

- **Interactive overlay content works as expected**
  - Buttons, menus, sheets, and other controls inside the overlay receive touches normally.
- **Touches outside overlay content pass through**
  - If the user taps on the overlay’s background, the window returns `nil` from hit-testing.
  - UIKit continues searching for a responder in the windows below.
- **Safe across iOS versions**
  - Handles double `hitTest` calls introduced in iOS 18
  - Correctly resolves hit-testing when using `UIHostingController`
  - Includes special handling for Liquid Glass–style layers on iOS 26+

---

## Typical Use Cases

- Toast notifications shown in a dedicated window
- Global network status banners
- Call or recording status overlays
- Debug or developer panels
- Context menus or lightweight modals that should not block the app

---

## Article

You can read more about this component [here](https://livsycode.com/uikit/passthroughwindow-in-ios26-an-overlay-window-that-doesnt-steal-your-gestures/)
