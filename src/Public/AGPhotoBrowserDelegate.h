//
//  AGPhotoBrowserDelegate.h
//  AGPhotoBrowser
//
//  Created by Andrea Giavatto on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AGPhotoBrowser;

@protocol AGPhotoBrowserDelegate <NSObject>

@optional
- (void)photoBrowser:(AGPhotoBrowser *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton;
- (void)photoBrowser:(AGPhotoBrowser *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index;

@end
