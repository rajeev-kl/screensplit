import Cocoa
import SwiftUI
import ApplicationServices

class GridWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}

class GridOverlayWindowController: NSWindowController {
    var overlayWindow: NSWindow!
    
    // We need to keep a reference to the previously focused window
    var targetWindow: AXUIElement?
    
    init() {
        let screenRect = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 800, height: 600)
        
        let window = GridWindow(
            contentRect: screenRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        window.level = .floating
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.ignoresMouseEvents = false
        window.acceptsMouseMovedEvents = true
        
        super.init(window: window)
        self.overlayWindow = window
        
        let contentView = GridOverlayView(
            onConfirm: { [weak self] rect in
                self?.applyGridRect(rect)
            },
            onCancel: { [weak self] in
                self?.close()
            }
        )
        
        window.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showWindow(_ sender: Any?) {
        // Record the frontmost window BEFORE we show the overlay and potentially take focus
        self.targetWindow = WindowManager.shared.getFrontmostWindow()
        
        // Ensure overlay appears on the active screen (where the mouse is)
        if let mouseLocation = NSEvent.mouseLocation as NSPoint?,
           let screen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) {
            self.window?.setFrame(screen.visibleFrame, display: true)
        } else if let mainScreen = NSScreen.main {
            self.window?.setFrame(mainScreen.visibleFrame, display: true)
        }
        
        super.showWindow(sender)
    }
    
    func applyGridRect(_ rect: CGRect) {
        self.close()
        
        if let targetWindow = self.targetWindow {
            WindowManager.shared.setWindow(targetWindow, frame: rect)
        } else {
            print("No target window to move.")
        }
    }
}
