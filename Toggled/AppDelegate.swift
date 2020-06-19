//
//  AppDelegate.swift
//  Toggled
//
//  Created by Joey Scarim on 6/19/20.
//  Copyright © 2020 Joey Scarim. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var popover: NSPopover!
    var statusBarItem: NSStatusItem!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
          let statusBar = NSStatusBar.system
           statusBarItem = statusBar.statusItem(
               withLength: NSStatusItem.squareLength)
           statusBarItem.button?.title = "✌️"

           let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
           statusBarItem.menu = statusBarMenu

        
        statusBarMenu.addItem(
                 withTitle: "Toggle Primary",
                 action: #selector(AppDelegate.orderABurrito),
                 keyEquivalent: "1")
        
           statusBarMenu.addItem(
               withTitle: "Toggle Secondary",
               action: #selector(AppDelegate.orderABurrito),
               keyEquivalent: "2")

           statusBarMenu.addItem(
               withTitle: "Toggle Dual",
               action: #selector(AppDelegate.cancelBurritoOrder),
               keyEquivalent: "3")

        

    }
    
    @objc func orderABurrito() {
          print("Ordering a burrito!")
      let displaysMirrored = CGDisplayIsInMirrorSet(CGMainDisplayID())
        print(displaysMirrored)
//        multiConfigureDisplays(configRef, secondaryDspys, numberOfOnlineDspys - 1, CGMainDisplayID());
//        CGDisplayConfigRef configRef;

        printDisplays()

//        CGGetActiveDisplayList(2)
//        let display2ID: UInt32 = 69733568
//        let configRef = CGDisplayConfigRef
//        CGBeginDisplayConfiguration(&configRef)
//        let id: CGDirectDisplayID

        var configRef: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&configRef)

        CGConfigureDisplayMirrorOfDisplay( configRef, CGMainDisplayID(), 69733568);
        CGCompleteDisplayConfiguration(configRef, .forSession)

//        1440 x 900
        

      }
    
   func printDisplays() {
           var displayCount: UInt32 = 0;
           var result = CGGetActiveDisplayList(0, nil, &displayCount)
               
           if result != .success {
               print("error: \(result)")
               return
           }

           let allocated = Int(displayCount)
           let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
           result = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
           if result != .success {
               print("error: \(result)")
               return
           }

//           print("\(displayCount) displays:")
           for i in 0..<displayCount {
               print("[\(i)] - \(activeDisplays[Int(i)])")
           }
    
    print( activeDisplays[Int(1)]);
    
           activeDisplays.deallocate()
       }


      @objc func cancelBurritoOrder() {
          print("Canceling your order :(")
//        var id: CGDirectDisplayID

        var token: CGDisplayConfigRef?
        CGBeginDisplayConfiguration(&token)
        CGConfigureDisplayMirrorOfDisplay(token, 69733568, kCGNullDirectDisplay)
        CGCompleteDisplayConfiguration(token, .forSession)
      }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    



}

