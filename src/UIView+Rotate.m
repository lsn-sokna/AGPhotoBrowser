//
//  UIView+Rotate.m
//  AGPhotoBrowser
//
//  Created by Hellrider on 4/18/14.
//  Copyright (c) 2014 Andrea Giavatto. All rights reserved.
//

#import "UIView+Rotate.h"

@implementation UIView (Rotate)

- (void)AG_rotateRadians:(double)radians
{
	CGAffineTransform rotateTable = CGAffineTransformMakeRotation(radians);
	CGPoint origin = self.frame.origin;
	self.transform = rotateTable;
	CGRect newFrame = self.frame;
	newFrame.origin = origin;
	self.frame = newFrame;
}

@end
