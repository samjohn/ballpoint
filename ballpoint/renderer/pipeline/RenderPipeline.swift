//
//  RendererPipeline.swift
//  ballpoint
//
//  Created by Tyler Heck on 11/7/15.
//  Copyright © 2015 Tyler Heck. All rights reserved.
//

import UIKit



/// A pipeline that transforms model strokes into renderer strokes.
class RenderPipeline {
  fileprivate let stages: [RenderPipelineStage]


  init(stages: RenderPipelineStage...) {
    self.stages = stages
  }


  /**
   - parameter stroke:

   - returns: The model stroke rendered as a CGPath.
   */
  func render(_ stroke: Stroke) -> [RenderedStroke.Path] {
    var scaffold = RenderScaffold()
    for s in stages {
      s.process(&scaffold, stroke: stroke)
    }

    assert(
        scaffold.doesDescribeCompleteStroke(),
        "Cannot render a RenderScaffold that does not describe a complete " +
        "stroke.")

    let path = CGMutablePath()
    for segment in scaffold.segments {
      segment.extendPath(path)
    }

    if path.isEmpty {
      return []
    }

    path.closeSubpath()
    var renderedPaths: [RenderedStroke.Path] = []
    renderedPaths.append(RenderedStroke.Path(
        cgPath: path, color: stroke.color.backingColor,
        mode: CGPathDrawingMode.fill))

    return renderedPaths
  }
}
