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
    
    var allPaths: [CGPath] = [path]
    if scaffold.points.count == 1 {
      for p in scaffold.points {
        let center = p.modelLocation
        let radius = PointUtil.distance(center, p.left)
        let ellipseRect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
        let path = CGPath(ellipseIn: ellipseRect, transform: nil)
        allPaths.append(path)
      }
    }
    
    var renderedPaths: [RenderedStroke.Path] = []
    for p in allPaths {
      renderedPaths.append(RenderedStroke.Path(
          cgPath: p, color: stroke.color.backingColor,
          mode: CGPathDrawingMode.fill))
    }
    return renderedPaths
  }
}
