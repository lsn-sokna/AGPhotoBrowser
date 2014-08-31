//
//  AGPhotoBrowserView.m
//  AGPhotoBrowser
//
//  Created by Andrea Giavatto on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import "AGPhotoBrowser.h"
#import "AGPhotoBrowserViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface AGPhotoBrowser () <AGPhotoBrowserDataSource, AGPhotoBrowserDelegate>

@property (nonatomic, strong) UIWindow *previousWindow;
@property (nonatomic, strong) UIWindow *currentWindow;

@property (atomic, assign) BOOL changingOrientation;
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end


@implementation AGPhotoBrowser

const CGFloat AGPhotoBrowserAnimationDuration = 0.25f;

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Initialization code
		[self setupView];
    }
    return self;
}

- (void)setupView
{
//	[[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(statusBarDidChangeFrame:)
//                                                 name:UIDeviceOrientationDidChangeNotification
//                                               object:nil];
}

- (void)dealloc
{
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - Public methods

- (void)show
{
    NSLog(@"This method has been deprecated and will be removed in a future release. Use showAnimated: instead.");
	return;
}

- (void)showAnimated:(BOOL)animated completion:(void (^)(BOOL))completionBlock
{
	self.previousWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.currentWindow = [[UIWindow alloc] initWithFrame:self.previousWindow.bounds];
    self.currentWindow.windowLevel = UIWindowLevelStatusBar;
    self.currentWindow.hidden = NO;
    self.currentWindow.backgroundColor = [UIColor clearColor];
	AGPhotoBrowserViewController *rootViewController = [[AGPhotoBrowserViewController alloc] init];
	rootViewController.delegate = self;
	rootViewController.dataSource = self;
	self.currentWindow.rootViewController = rootViewController;
    [self.currentWindow makeKeyAndVisible];
	
	NSTimeInterval animationDuration = AGPhotoBrowserAnimationDuration;
	if (!animated) {
		animationDuration = 0.0f;
	}
	
	[UIView animateWithDuration:animationDuration
					 animations:^(){
						 self.currentWindow.backgroundColor = [UIColor colorWithWhite:0. alpha:1.];
					 }
					 completion:^(BOOL finished){
//						 self.userInteractionEnabled = YES;
//						 self.displayingDetailedView = YES;
//						 self.photoCollectionView.alpha = 1.;
//						 [self.photoCollectionView reloadData];
//						 
						 if (completionBlock) {
							 completionBlock(finished);
						 }
					 }];
}

- (void)showFromIndex:(NSInteger)initialIndex
{
	NSLog(@"This method has been deprecated and will be removed in a future release. Use showFromIndex:animated: instead.");
	return;
}

- (void)showFromIndex:(NSInteger)initialIndex animated:(BOOL)animated completion:(void (^)(BOOL))completionBlock
{
	[self showAnimated:animated
		completion:^(BOOL finished) {
			if (initialIndex < [self.dataSource numberOfPhotosForPhotoBrowser:self]) {
//				[self.photoCollectionView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:initialIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
			}
			if (completionBlock) {
				completionBlock(finished);
			}
		}];
}

- (void)hideWithCompletion:(void(^)(BOOL finished))completionBlock
{
	NSLog(@"This method has been deprecated and will be removed in a future release. Use hideAnimated:withCompletion: instead.");
	return;
}

- (void)hideAnimated:(BOOL)animated completion:(void (^)(BOOL))completionBlock
{
	NSTimeInterval animationDuration = AGPhotoBrowserAnimationDuration;
	if (!animated) {
		animationDuration = 0.f;
	}
	[UIView animateWithDuration:animationDuration
					 animations:^(){
//						 self.photoCollectionView.alpha = 0.;
						 self.currentWindow.backgroundColor = [UIColor colorWithWhite:0. alpha:0.];
					 }
					 completion:^(BOOL finished){
//						 self.userInteractionEnabled = NO;
//                         [self removeFromSuperview];
                         [self.previousWindow makeKeyAndVisible];
                         self.currentWindow.hidden = YES;
                         self.currentWindow = nil;
						 
						 if(completionBlock) {
							 completionBlock(finished);
						 }
					 }];
}

#pragma mark - AGPhotoBrowserDelegate (Proxy)

- (void)photoBrowser:(AGPhotoBrowser *)photoBrowser didTapOnActionButton:(UIButton *)actionButton atIndex:(NSInteger)index
{
	if ([self.delegate respondsToSelector:@selector(photoBrowser:didTapOnActionButton:atIndex:)]) {
		[self.delegate photoBrowser:self didTapOnActionButton:actionButton atIndex:index];
	}
}

- (void)photoBrowser:(AGPhotoBrowser *)photoBrowser didTapOnDoneButton:(UIButton *)doneButton
{
	if ([self.delegate respondsToSelector:@selector(photoBrowser:didTapOnDoneButton:)]) {
		[self.delegate photoBrowser:self didTapOnDoneButton:doneButton];
	}
}

#pragma mark - AGPhotoBrowserDataSource (Proxy)

- (NSInteger)numberOfPhotosForPhotoBrowser:(AGPhotoBrowser *)photoBrowser
{
	return [self.dataSource numberOfPhotosForPhotoBrowser:self];
}

- (UIImage *)photoBrowser:(AGPhotoBrowser *)photoBrowser imageAtIndex:(NSInteger)index
{
	UIImage *image = nil;
	if ([self.dataSource respondsToSelector:@selector(photoBrowser:imageAtIndex:)]) {
		image = [self.dataSource photoBrowser:self imageAtIndex:index];
	}
	
	return image;
}

- (UICollectionViewCell<AGPhotoBrowserCellProtocol> *)cellForBrowser:(AGPhotoBrowser *)browser withReuseIdentifier:(NSString *)reuseIdentifier
{
	UICollectionViewCell<AGPhotoBrowserCellProtocol> *cell;
	if ([self.dataSource respondsToSelector:@selector(cellForBrowser:withReuseIdentifier:)]) {
		cell = [self.dataSource cellForBrowser:self withReuseIdentifier:reuseIdentifier];
	}
	
	return cell;
}

- (NSString *)photoBrowser:(AGPhotoBrowser *)photoBrowser URLStringForImageAtIndex:(NSInteger)index
{
	NSString *URLString = nil;
	if ([self.dataSource respondsToSelector:@selector(photoBrowser:URLStringForImageAtIndex:)]) {
		URLString = [self.dataSource photoBrowser:self URLStringForImageAtIndex:index];
	}
	
	return URLString;
}

- (NSString *)photoBrowser:(AGPhotoBrowser *)photoBrowser titleForImageAtIndex:(NSInteger)index
{
	NSString *titleString = nil;
	if ([self.dataSource respondsToSelector:@selector(photoBrowser:titleForImageAtIndex:)]) {
		titleString = [self.dataSource photoBrowser:self titleForImageAtIndex:index];
	}
	
	return titleString;
}

- (NSString *)photoBrowser:(AGPhotoBrowser *)photoBrowser descriptionForImageAtIndex:(NSInteger)index
{
	NSString *descriptionString = nil;
	if ([self.dataSource respondsToSelector:@selector(photoBrowser:descriptionForImageAtIndex:)]) {
		descriptionString = [self.dataSource photoBrowser:self descriptionForImageAtIndex:index];
	}
	
	return descriptionString;
}

- (BOOL)photoBrowser:(AGPhotoBrowser *)photoBrowser willDisplayActionButtonAtIndex:(NSInteger)index
{
	BOOL willDisplayActionButton = NO;
	if ([self.dataSource respondsToSelector:@selector(photoBrowser:willDisplayActionButtonAtIndex:)]) {
		willDisplayActionButton = [self.dataSource photoBrowser:self willDisplayActionButtonAtIndex:index];
	}
	
	return willDisplayActionButton;
}

- (BOOL)photoBrowser:(AGPhotoBrowser *)photoBrowser shouldDisplayOverlayViewAtIndex:(NSInteger)index
{
	BOOL shouldDisplayOverlayView = NO;
	if ([self.dataSource respondsToSelector:@selector(photoBrowser:shouldDisplayOverlayViewAtIndex:)]) {
		shouldDisplayOverlayView = [self.dataSource photoBrowser:self shouldDisplayOverlayViewAtIndex:index];
	}
	
	return shouldDisplayOverlayView;
}




//#pragma mark - Orientation change
//
//- (void)statusBarDidChangeFrame:(NSNotification *)notification
//{
//	self.changingOrientation = YES;
//	
//    // -- Get the device orientation
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//	
//	CGFloat angleTable = UIInterfaceOrientationAngleOfOrientation(orientation);
//	CGAffineTransform viewTransform = CGAffineTransformMakeRotation(angleTable);
//	CGRect viewFrame = [UIScreen mainScreen].bounds;
//	
//	// -- Update table
//	[self setTransform:viewTransform andFrame:viewFrame forView:self];
//	[self setNeedsUpdateConstraints];
//	
//	[self.photoCollectionView reloadData];
//	[self.photoCollectionView layoutIfNeeded];
////	[self.photoCollectionView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentlySelectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
//	
//	self.changingOrientation = NO;
//}
//
//- (void)setTransform:(CGAffineTransform)transform andFrame:(CGRect)frame forView:(UIView *)view
//{
//	if (!CGAffineTransformEqualToTransform(view.transform, transform)) {
//        view.transform = transform;
//    }
//    if (!CGRectEqualToRect(view.frame, frame)) {
//        view.frame = frame;
//    }
//}
//
//CGFloat UIInterfaceOrientationAngleOfOrientation(UIDeviceOrientation orientation)
//{
//    CGFloat angle;
//    
//    switch (orientation) {
//        case UIDeviceOrientationLandscapeLeft:
//            angle = 0;
//            break;
//        case UIDeviceOrientationLandscapeRight:
//            angle = M_PI;
//            break;
//        default:
//            angle = -M_PI_2;
//            break;
//    }
//    
//    return angle;
//}

@end
