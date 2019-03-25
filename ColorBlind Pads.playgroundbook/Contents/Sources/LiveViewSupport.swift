//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  Provides supporting functions for setting up a live view.
//

import UIKit
import PlaygroundSupport

/// Instantiates a new instance of a live view.
///
/// By default, this loads an instance of `LiveViewController` from `LiveView.storyboard`.
public func instantiateLiveView(chapter: Int, page: Int) -> PlaygroundLiveViewable {
    let storyBoardName = "LiveView_1_1"
    let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)

    guard let viewController = storyboard.instantiateInitialViewController() else {
        fatalError("\(storyBoardName).storyboard does not have an initial scene; please set one or update this function")
    }

    guard let liveViewController = viewController as? LiveViewController else {
        fatalError("\(storyBoardName).storyboard's initial scene is not a LiveViewController; please either update the storyboard or this function")
    }
    
    var filter: Filter = .common
    switch page {
    case 2:
        filter = .withFilter
    case 3:
        filter = .withSymbols
    default:
        break
    }

    (liveViewController as? PadsViewController)?.filter = filter
    
    return liveViewController
}

// - MARK: Custom code from WWDC 2018 Session 413

public protocol PlaygroundValueConvertible {
    func asPlaygroundValue() -> PlaygroundValue
}

// For custom values which implements the PlaygroundValueConvertible protocol
public func sendValue(_ value: PlaygroundValueConvertible) {
    let page = PlaygroundPage.current
    let proxy = page.liveView as! PlaygroundRemoteLiveViewProxy
    proxy.send(value.asPlaygroundValue())
}

// For simple PlaygroundValue supported values
public func sendValue(_ value: PlaygroundValue) {
    let page = PlaygroundPage.current
    let proxy = page.liveView as! PlaygroundRemoteLiveViewProxy
    proxy.send(value)
}
