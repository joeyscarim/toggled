//
//  AppDelegate.swift
//  Toggled
//
//  Created by Joey Scarim on 6/19/20.
//  Copyright © 2020 Joey Scarim. All rights reserved.
//
//

// thank yous / code inspiration / doc sources
// https://github.com/elegantchaos/Displays/blob/c7ff510c643dd21871ba1da6e4347dcf11124e50/Sources/Displays/Display.swift
// https://gist.github.com/lilyball/569d5ba0f1b0961a15c0

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarItem: NSStatusItem!
    var secondaryDisplayId: UInt32!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // status bar menu setup
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem(
            withLength: NSStatusItem.squareLength)
        
        statusBarItem.button?.title =  "✌️"
        
        let statusBarMenu = NSMenu(title: "")
        statusBarItem.menu = statusBarMenu
        
        // set the secondary monitor id, used in toggleSecondary
        findAndSetSecondaryDisplayId()
        
        // build the menu
        statusBarMenu.addItem(
            withTitle: "Toggle Secondary",
            action: #selector(AppDelegate.toggleSecondary),
            keyEquivalent: "1")
        
        statusBarMenu.addItem(
            withTitle: "Toggle Dual",
            action: #selector(AppDelegate.toggleDual),
            keyEquivalent: "2")
        
        statusBarMenu.insertItem(NSMenuItem.separator(), at: 2)
        
        statusBarMenu.addItem(
            withTitle: "About",
            action: #selector(AppDelegate.aboutApp),
            keyEquivalent: "")
        
        statusBarMenu.addItem(
            withTitle: "Quit",
            action: #selector(AppDelegate.quitApp),
            keyEquivalent: "")
    }
    
    
    @objc func aboutApp(){
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Toggled, v1.0", comment: "")
        alert.informativeText = NSLocalizedString("by Joey Scarim", comment: "")
        alert.addButton(withTitle: NSLocalizedString("Close", comment: ""))
        alert.runModal()
    }
    
    @objc func quitApp(){
        for runningApplication in NSWorkspace.shared.runningApplications {
            let appName = runningApplication.localizedName
            if appName == "Toggled" {
                runningApplication.terminate()
            }
        }
    }
    
    // set mirror mode to set main display to match secondary
    @objc func toggleSecondary() {
        statusBarItem.button?.title =   "☝️"
        
        var configRef: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&configRef)
        CGConfigureDisplayMirrorOfDisplay( configRef, CGMainDisplayID(), secondaryDisplayId);
        CGCompleteDisplayConfiguration(configRef, .forSession)
    }
    
    // set mirror mode to null, null
    @objc func toggleDual() {
        statusBarItem.button?.title =  "✌️"
        
        var configRef: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&configRef)
        CGConfigureDisplayMirrorOfDisplay(configRef, kCGNullDirectDisplay, kCGNullDirectDisplay)
        CGCompleteDisplayConfiguration(configRef, .forSession)
    }
    
    // find and set secondary display id
    func findAndSetSecondaryDisplayId() {
        
        // get count of attached monitors
        var displayCount: UInt32 = 0;
        CGGetActiveDisplayList(0, nil, &displayCount)
        print(displayCount)
        
        // create array of active display ids
        let allocated = Int(2)
        let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
        CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
        
        // set secondary display id to active display at position 2/ index 1
        secondaryDisplayId = activeDisplays[Int(1)]
        
        // cleanup
        activeDisplays.deallocate()
    }
    
    
}

