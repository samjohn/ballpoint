//
//  CircularBrush.swift
//  inkwell
//
//  Created by Tyler Heck on 8/2/15.
//  Copyright (c) 2015 Tyler Heck. All rights reserved.
//

import UIKit



/// A brush that paints by drawing a path at the desired location.
class CircularBrush: Brush {
  /// The brush path.
  private let circlePath: CGPath
  
  /// The radius of the brush path.
  private let radius: CGFloat
  
  
  /**
   - parameter radius: The radius of the brush.
   */
  init(radius: CGFloat) {
    let path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, radius, 0)
    CGPathAddArc(path, nil, 0, 0, radius, 0, CGFloat(M_PI), true)
    CGPathAddArc(
        path, nil, 0, 0, radius, CGFloat(M_PI), CGFloat(2 * M_PI), true)
    CGPathCloseSubpath(path)
    circlePath = path
    self.radius = radius
  }
  
  
  /// MARK: Brush method implementations.

  func render(stroke: Stroke) -> RendererStroke? {
    if stroke.points.isEmpty {
      return nil
    }

    var paths: [CGPath] = []

    paths.append(circularPathAtLocation(stroke.points.first!))
    
    if stroke.points.count > 1 {
      for i in 1..<stroke.points.count {
        paths.append(connectorPathFromLocation(
            stroke.points[i - 1], toLocation: stroke.points[i]))
        paths.append(circularPathAtLocation(stroke.points[i]))
      }
    }

    return RendererStroke(paths: paths, color: stroke.color)
  }

  
  /// MARK: Helper methods.
  
  /**
   - parameter location:

   - returns: The circular path centered at the given location.
   */
  private func circularPathAtLocation(location: CGPoint) -> CGPath {
    var translation = CGAffineTransformMakeTranslation(
        location.x, location.y)
    let translatedPath = CGPathCreateCopyByTransformingPath(
        circlePath, &translation)
    assert(translatedPath != nil, "Could not translate circular brush path.")
    return translatedPath!
  }
  
  
  /**
   - parameter a:
   - parameter b: Method assumes that b != a.

   - returns: The rectangular path from point A to B. One pair of sides runs
       parallel to the line between the two points (with equivalent length to
       the line between the points). The other pair of sides runs perpendicular
       to the line between the two points, with length equal to twice the radius
       and centered on each of the points.
   */
  private func connectorPathFromLocation(
      a: CGPoint, toLocation b: CGPoint) -> CGPath {
    let path = CGPathCreateMutable()
    
    // Special case when a.y == b.y, because then the perpendicular slope will
    // be infinite.
    if (a.y == b.y) {
      CGPathMoveToPoint(path, nil, a.x, a.y - radius)
      CGPathAddLineToPoint(path, nil, b.x, b.y - radius)
      CGPathAddLineToPoint(path, nil, b.x, b.y + radius)
      CGPathAddLineToPoint(path, nil, a.x, a.y + radius)
      CGPathCloseSubpath(path)
      return path
    }
    
    // Special case when a.x == b.x, because then the perpendicular slope will
    // be 0.
    if (a.x == b.x) {
      CGPathMoveToPoint(path, nil, a.x - radius, a.y)
      CGPathAddLineToPoint(path, nil, b.x - radius, b.y)
      CGPathAddLineToPoint(path, nil, b.x + radius, b.y)
      CGPathAddLineToPoint(path, nil, a.x + radius, a.y)
      CGPathCloseSubpath(path)
      return path
    }
    
    let perpendicularSlope = -((a.x - b.x) / (a.y - b.y))
    let perpendicularAIntercept = a.y - perpendicularSlope * a.x
    let perpendicularBIntercept = b.y - perpendicularSlope * b.x
    
    // The change in x required to move the size of the radius from a point
    // along the slope perpendicular to the line between a and b.
    let deltaX = sqrt(
        (radius * radius) / (1 + perpendicularSlope * perpendicularSlope))
    
    var x = a.x + deltaX
    var y = perpendicularSlope * x + perpendicularAIntercept
    CGPathMoveToPoint(path, nil, x, y)
    
    x = b.x + deltaX
    y = perpendicularSlope * x + perpendicularBIntercept
    CGPathAddLineToPoint(path, nil, x, y)
    
    x = b.x - deltaX
    y = perpendicularSlope * x + perpendicularBIntercept
    CGPathAddLineToPoint(path, nil, x, y)
    
    x = a.x - deltaX
    y = perpendicularSlope * x + perpendicularAIntercept
    CGPathAddLineToPoint(path, nil, x, y)
    CGPathCloseSubpath(path)
    
    return path
  }
}