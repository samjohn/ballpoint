//
//  MenuView.swift
//  ballpoint
//
//  Created by Tyler Heck on 4/24/16.
//  Copyright © 2016 Tyler Heck. All rights reserved.
//

import UIKit



// The menu of buttons that trigger actions within the app.
class MenuView: UIView {
  // The desired size of the menu view buttons.
  private static let kMenuButtonSize: CGFloat = 44

  // The number of menu view buttons.
  private static let kMenuButtonCount: Int = 5

  // The opacity of the menu shadow.
  static let kShadowOpacity: CGFloat = 0.2

  // The overflow fo the menu shadow.
  static let kShadowOverflow: CGSize =
      CGSize(width: 3, height: 3)

  // The desired size of the menu view for full display.
  let desiredSize = CGSize(
      width: MenuView.kMenuButtonSize * CGFloat(MenuView.kMenuButtonCount) +
          kShadowOverflow.width,
      height: MenuView.kMenuButtonSize + kShadowOverflow.height)

  // Actions that will be triggered when buttons are pressed.
  var eraseAction: (() -> Void)? {
    get {
      return eraseButton.pressAction
    }
    set {
      eraseButton.pressAction = newValue
    }
  }
  var undoAction: (() -> Void)? {
    get {
      return undoButton.pressAction
    }
    set {
      undoButton.pressAction = newValue
    }
  }
  var redoAction: (() -> Void)? {
    get {
      return redoButton.pressAction
    }
    set {
      redoButton.pressAction = newValue
    }
  }
  var saveAction: (() -> Void)? {
    get {
      return saveButton.pressAction
    }
    set {
      saveButton.pressAction = newValue
    }
  }
  var clearAction: (() -> Void)? {
    get {
      return clearButton.pressAction
    }
    set {
      clearButton.pressAction = newValue
    }
  }

  // The shadow of the menu.
  private let menuShadow: UIView

  // The containing view for underlying buttons.
  private let buttonContainer: UIView

  // Buttons within the menu.
  private let eraseButton: DepressableButton
  private let undoButton: DepressableButton
  private let redoButton: DepressableButton
  private let saveButton: DepressableButton
  private let clearButton: DepressableButton


  // The menu will be created at desired size, and can be resized as needed
  // after creation.
  init() {
    menuShadow = UIView()
    buttonContainer = UIView()
    eraseButton = DepressableButton(frame: CGRect.zero)
    undoButton = DepressableButton(frame: CGRect.zero)
    redoButton = DepressableButton(frame: CGRect.zero)
    saveButton = DepressableButton(frame: CGRect.zero)
    clearButton = DepressableButton(frame: CGRect.zero)
    let frame = CGRect(origin: CGPoint.zero, size: desiredSize)
    super.init(frame: frame)

    addSubview(menuShadow)
    addSubview(buttonContainer)
    buttonContainer.addSubview(eraseButton)
    buttonContainer.addSubview(undoButton)
    buttonContainer.addSubview(redoButton)
    buttonContainer.addSubview(saveButton)
    buttonContainer.addSubview(clearButton)

    menuShadow.frame = frame
    let containerOrigin = CGPoint(x: MenuView.kShadowOverflow.width / 2, y: 0)
    let containerSize = CGSize(
        width: MenuView.kMenuButtonSize * CGFloat(MenuView.kMenuButtonCount),
        height: MenuView.kMenuButtonSize)
    buttonContainer.frame = CGRect(origin: containerOrigin, size: containerSize)
    let buttonSize = CGSize(
        width: MenuView.kMenuButtonSize,
        height: MenuView.kMenuButtonSize)
    let buttons = [eraseButton, undoButton, redoButton, saveButton, clearButton]
    for i in 0..<MenuView.kMenuButtonCount {
      buttons[i].frame = CGRect(
          origin: CGPoint(x: MenuView.kMenuButtonSize * CGFloat(i), y: 0),
          size: buttonSize)
    }

    let allViews = [
      menuShadow, buttonContainer, eraseButton, undoButton, redoButton,
      saveButton, clearButton
    ]
    let autoSizeParams: UIViewAutoresizing = [
      UIViewAutoresizing.FlexibleHeight,
      UIViewAutoresizing.FlexibleWidth,
      UIViewAutoresizing.FlexibleTopMargin,
      UIViewAutoresizing.FlexibleBottomMargin,
      UIViewAutoresizing.FlexibleLeftMargin,
      UIViewAutoresizing.FlexibleRightMargin,
    ]
    for view in allViews {
      view.autoresizingMask = autoSizeParams
    }

    menuShadow.backgroundColor = UIColor.darkGrayColor()
    menuShadow.alpha = MenuView.kShadowOpacity
    buttonContainer.backgroundColor = UIColor.lightGrayColor()


    eraseButton.setTitle("E", forState: UIControlState.Normal)
    undoButton.setTitle("U", forState: UIControlState.Normal)
    redoButton.setTitle("R", forState: UIControlState.Normal)
    saveButton.setTitle("S", forState: UIControlState.Normal)
    clearButton.setTitle("C", forState: UIControlState.Normal)
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
