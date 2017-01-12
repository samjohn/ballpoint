//
//  Constants.swift
//  ballpoint
//
//  Created by Tyler Heck on 8/26/15.
//  Copyright (c) 2015 Tyler Heck. All rights reserved.
//

import UIKit



class Constants {
  /// The minimum size of strokes.
  static let kProportionalStrokeRadius: CGFloat = 2

  /// The brush used for the pen tool.
  static let kPenBrush = PipelineBrush()

  /// The brush used for the eraser tool.
  static let kEraserBrush = PipelineBrush()

  // The color ids for renderer colors uses in the application.
  static let kBallpointInkColorId: RendererColorId =
      "renderer-color-ballpoint-ink-color-id"
  static let kBallpointSurfaceColorId: RendererColorId =
      "renderer-color-ballpoint-surface-color-id"
}
