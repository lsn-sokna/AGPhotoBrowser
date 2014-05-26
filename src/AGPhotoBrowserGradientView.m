//
//  AGGradientView.m
//  AGPhotoBrowser
//
//  Created by Andrea Giavatto on 5/5/14.
//  Copyright (c) 2014 Andrea Giavatto. All rights reserved.
//

#import "AGPhotoBrowserGradientView.h"

@implementation AGPhotoBrowserGradientView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

@end
