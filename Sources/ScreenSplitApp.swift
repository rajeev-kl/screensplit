import SwiftUI
import AppKit
import ServiceManagement

@main
struct ScreenSplitApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var overlayWindowController: GridOverlayWindowController?
    var hotkeyManager: HotkeyManager?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        // Ensure only one instance of the app runs at a time
        let bundleID = Bundle.main.bundleIdentifier ?? "com.rajeev.ScreenSplit"
        let runningApps = NSRunningApplication.runningApplications(withBundleIdentifier: bundleID)
        
        if runningApps.count > 1 {
            // Another instance is already running, exit this one immediately
            print("Another instance is already running. Exiting.")
            NSApp.terminate(nil)
        }
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Request Accessibility permissions if not granted
        if !AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary) {
            print("Accessibility permissions not granted. Prompting user.")
        }
        
        setupMenu()
        
        overlayWindowController = GridOverlayWindowController()
        
        hotkeyManager = HotkeyManager { [weak self] in
            self?.toggleOverlay()
        }
    }
    
    var columnsMenu: NSMenu!
    var rowsMenu: NSMenu!
    var launchAtStartupItem: NSMenuItem!
    
    func setupMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "squareshape.split.3x3", accessibilityDescription: "ScreenSplit")
        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show Grid (Cmd+G)", action: #selector(toggleOverlay), keyEquivalent: "g"))
        menu.items.last?.keyEquivalentModifierMask = [.command]
        
        menu.addItem(NSMenuItem.separator())
        
        // Grid Configuration
        let configItem = NSMenuItem(title: "Grid Configuration", action: nil, keyEquivalent: "")
        let configMenu = NSMenu()
        
        let columnsItem = NSMenuItem(title: "Columns", action: nil, keyEquivalent: "")
        columnsMenu = NSMenu()
        for opt in [0, 3, 4, 5, 6] {
            let title = opt == 0 ? "Auto" : "\(opt)"
            let item = NSMenuItem(title: title, action: #selector(setColumns(_:)), keyEquivalent: "")
            item.tag = opt
            item.target = self
            columnsMenu.addItem(item)
        }
        columnsItem.submenu = columnsMenu
        configMenu.addItem(columnsItem)
        
        let rowsItem = NSMenuItem(title: "Rows", action: nil, keyEquivalent: "")
        rowsMenu = NSMenu()
        for opt in [0, 3, 4, 5, 6] {
            let title = opt == 0 ? "Auto" : "\(opt)"
            let item = NSMenuItem(title: title, action: #selector(setRows(_:)), keyEquivalent: "")
            item.tag = opt
            item.target = self
            rowsMenu.addItem(item)
        }
        rowsItem.submenu = rowsMenu
        configMenu.addItem(rowsItem)
        
        let templatesItem = NSMenuItem(title: "Templates", action: nil, keyEquivalent: "")
        let templatesMenu = NSMenu()
        
        let v11 = NSMenuItem(title: "1:1 Vertical", action: #selector(setTemplate(_:)), keyEquivalent: "")
        v11.representedObject = [2, 1]
        v11.target = self
        templatesMenu.addItem(v11)
        
        let h11 = NSMenuItem(title: "1:1 Horizontal", action: #selector(setTemplate(_:)), keyEquivalent: "")
        h11.representedObject = [1, 2]
        h11.target = self
        templatesMenu.addItem(h11)
        
        let thirds = NSMenuItem(title: "1:1:1 / 1:2", action: #selector(setTemplate(_:)), keyEquivalent: "")
        thirds.representedObject = [3, 1]
        thirds.target = self
        templatesMenu.addItem(thirds)
        
        templatesItem.submenu = templatesMenu
        configMenu.addItem(templatesItem)
        
        configItem.submenu = configMenu
        menu.addItem(configItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Launch at startup
        launchAtStartupItem = NSMenuItem(title: "Launch at Startup", action: #selector(toggleLaunchAtStartup), keyEquivalent: "")
        launchAtStartupItem.target = self
        menu.addItem(launchAtStartupItem)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit ScreenSplit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
        updateMenuStates()
    }
    
    @objc func toggleLaunchAtStartup() {
        if #available(macOS 13.0, *) {
            do {
                if SMAppService.mainApp.status == .enabled {
                    try SMAppService.mainApp.unregister()
                } else {
                    try SMAppService.mainApp.register()
                }
                updateMenuStates()
            } catch {
                print("Failed to toggle launch at startup: \(error)")
            }
        } else {
            print("Launch at startup requires macOS 13.0 or later.")
        }
    }
    
    @objc func setColumns(_ sender: NSMenuItem) {
        UserDefaults.standard.set(sender.tag, forKey: "GridColumnsConfig")
        updateMenuStates()
    }
    
    @objc func setRows(_ sender: NSMenuItem) {
        UserDefaults.standard.set(sender.tag, forKey: "GridRowsConfig")
        updateMenuStates()
    }
    
    @objc func setTemplate(_ sender: NSMenuItem) {
        if let config = sender.representedObject as? [Int], config.count == 2 {
            UserDefaults.standard.set(config[0], forKey: "GridColumnsConfig")
            UserDefaults.standard.set(config[1], forKey: "GridRowsConfig")
            updateMenuStates()
        }
    }
    
    func updateMenuStates() {
        let cols = UserDefaults.standard.integer(forKey: "GridColumnsConfig")
        let rows = UserDefaults.standard.integer(forKey: "GridRowsConfig")
        
        for item in columnsMenu.items {
            item.state = (item.tag == cols) ? .on : .off
        }
        
        for item in rowsMenu.items {
            item.state = (item.tag == rows) ? .on : .off
        }
        
        if #available(macOS 13.0, *) {
            launchAtStartupItem.state = SMAppService.mainApp.status == .enabled ? .on : .off
        }
    }
    
    @objc func toggleOverlay() {
        if overlayWindowController?.window?.isVisible == true {
            overlayWindowController?.close()
        } else {
            overlayWindowController?.showWindow(nil)
            overlayWindowController?.window?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
