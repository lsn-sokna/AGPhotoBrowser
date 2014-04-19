//
//  AGPhotoBrowserZoomableView.m
//  AGPhotoBrowser
//
//  Created by Andrea Giavatto on 24/11/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import "AGPhotoBrowserZoomableView.h"


@interface AGPhotoBrowserZoomableView ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation AGPhotoBrowserZoomableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 3.0f;
        
        [self addGestureRecognizer:self.tapGesture];
        [self addSubview:self.imageView];
    }
    return self;
}


#pragma mark - Getters

- (UITapGestureRecognizer *)tapGesture
{
	if (!_tapGesture) {
		_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_imageTapped:)];
		_tapGesture.numberOfTapsRequired = 2;
	}
	
	return _tapGesture;
}

- (UIImageView *)imageView
{
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithFrame:self.frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	}
	
	return _imageView;
}


#pragma mark - Public methods

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}


#pragma mark - Touch handling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.zoomableDelegate respondsToSelector:@selector(didDoubleTapZoomableView:)]) {
        [self.zoomableDelegate didDoubleTapZoomableView:self];
    }
}


#pragma mark - Private methods

- (void)p_imageTapped:(UITapGestureRecognizer *)recognizer
{
    if (self.zoomScale > 1.0f) {
        [UIView animateWithDuration:0.25 animations:^{
            self.zoomScale = 1.0f;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            CGPoint point = [recognizer locationInView:self];
            [self zoomToRect:CGRectMake(point.x, point.y, 0, 0) animated:YES];
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

@end
