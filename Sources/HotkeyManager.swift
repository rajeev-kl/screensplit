import Cocoa
import Carbon

class HotkeyManager {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
        registerHotkey()
    }
    
    private func registerHotkey() {
        var hotKeyRef: EventHotKeyRef?
        let hotKeyID = EventHotKeyID(signature: OSType("grdt".utf8.reduce(0) { $0 << 8 + UInt32($1) }), id: 1)
        
        // Key code for 'G' is 5. Modifier for Command is cmdKey.
        let keyCode: UInt32 = 5 
        let modifiers: UInt32 = UInt32(cmdKey)
        
        let status = RegisterEventHotKey(
            keyCode,
            modifiers,
            hotKeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
        
        if status != noErr {
            print("Failed to register hotkey")
        }
        
        let eventSpec = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        // We have to pass `self` so the callback can access it. Since InstallEventHandler takes a C function pointer,
        // we use a static or closure approach. But Carbon requires a C function.
        let ptr = Unmanaged.passUnretained(self).toOpaque()
        
        InstallEventHandler(GetApplicationEventTarget(), { (nextHandler, theEvent, userData) -> OSStatus in
            let mySelf = Unmanaged<HotkeyManager>.fromOpaque(userData!).takeUnretainedValue()
            mySelf.action()
            return noErr
        }, 1, [eventSpec], ptr, nil)
    }
}
