import Foundation
import ApplicationServices
import Cocoa

class WindowManager {
    static let shared = WindowManager()
    
    private init() {}
    
    func getFrontmostWindow() -> AXUIElement? {
        guard let frontmostApp = NSWorkspace.shared.frontmostApplication else { return nil }
        
        let appElement = AXUIElementCreateApplication(frontmostApp.processIdentifier)
        
        var focusedWindow: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(appElement, kAXFocusedWindowAttribute as CFString, &focusedWindow)
        
        if result == .success {
            return (focusedWindow as! AXUIElement)
        }
        
        return nil
    }
    
    func setWindow(_ windowElement: AXUIElement, frame: CGRect) {
        var position = frame.origin
        var size = frame.size
        
        // Some applications require setting size first, then position, then size again to ensure it fits within screen bounds correctly.
        if let sizeValue = AXValueCreate(.cgSize, &size) {
            AXUIElementSetAttributeValue(windowElement, kAXSizeAttribute as CFString, sizeValue)
        }
        
        if let positionValue = AXValueCreate(.cgPoint, &position) {
            AXUIElementSetAttributeValue(windowElement, kAXPositionAttribute as CFString, positionValue)
        }
        
        if let sizeValue = AXValueCreate(.cgSize, &size) {
            AXUIElementSetAttributeValue(windowElement, kAXSizeAttribute as CFString, sizeValue)
        }
    }
}
