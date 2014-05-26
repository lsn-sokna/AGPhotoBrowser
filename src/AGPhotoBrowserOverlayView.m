//
//  AGPhotoBrowserOverlayView.m
//  AGPhotoBrowser
//
//  Created by Andrea Giavatto on 7/28/13.
//  Copyright (c) 2013 Andrea Giavatto. All rights reserved.
//

#import "AGPhotoBrowserOverlayView.h"
#import "AGPhotoBrowserGradientView.h"
#import <QuartzCore/QuartzCore.h>


@interface AGPhotoBrowserOverlayView () {
	BOOL _animated;
    
    CAGradientLayer *_gradientLayer;
}

@property (nonatomic, strong) AGPhotoBrowserGradientView *sharingView;
@property (nonatomic, assign, readwrite) BOOL descriptionExpanded;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIButton *seeMoreButton;
@property (nonatomic, strong, readwrite) UIButton *actionButton;

@property (nonatomic, assign, readwrite, getter = isVisible) BOOL visible;

@end


@implementation AGPhotoBrowserOverlayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self p_setupView];
    }
    return self;
}

- (void)p_setupView
{
	self.alpha = 0;
    
	[self.sharingView addSubview:self.titleLabel];
	[self.sharingView addSubview:self.separatorView];
	[self.sharingView addSubview:self.descriptionLabel];
	[self.sharingView addSubview:self.seeMoreButton];
	[self.sharingView addSubview:self.actionButton];
	
	[self addSubview:self.sharingView];
	[self addGestureRecognizer:self.tapGesture];
}

- (void)updateConstraints
{
	[self removeConstraints:self.constraints];
	
	NSDictionary *constrainedViews = NSDictionaryOfVariableBindings(_sharingView, _titleLabel, _separatorView, _descriptionLabel);
	NSDictionary *metrics = @{@"SharingViewHeight" : @(100)}; // -- Magic number
	
	// -- Horizontal constraints
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_sharingView]|" options:0 metrics:metrics views:constrainedViews]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==20)-[_titleLabel]-(==20)-|" options:0 metrics:metrics views:constrainedViews]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==20)-[_separatorView]-(==20)-|" options:0 metrics:metrics views:constrainedViews]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==20)-[_descriptionLabel]-(==20)-|" options:0 metrics:metrics views:constrainedViews]];
	// -- Vertical constraints
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[_sharingView(==SharingViewHeight)]|" options:0 metrics:metrics views:constrainedViews]];
	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==30)-[_titleLabel(==20)][_separatorView(==1)]-[_descriptionLabel(>=20)]-(>=0)-|" options:0 metrics:metrics views:constrainedViews]];
	
	[super updateConstraints];
}

//- (void)layoutSubviews
//{
//	[super layoutSubviews];
//    
//    // -- Gradient layer
//    _gradientLayer.frame = self.bounds;
//    // -- Sharing view
//    self.sharingView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
//	// -- Title
//    self.titleLabel.frame = CGRectMake(20, 30, CGRectGetWidth(self.bounds) - 40, 20);
//	// -- Separator
//    self.separatorView.frame = CGRectMake(20, CGRectGetMinY(self.titleLabel.frame) + CGRectGetHeight(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), 1);
//    // -- Action
//    self.actionButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - 55 - 5, CGRectGetHeight(self.bounds) - 32 - 5, 55, 32);
//    // -- See more
//	self.seeMoreButton.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.actionButton.frame) - 60 - 5, CGRectGetMinY(self.separatorView.frame) + CGRectGetHeight(self.separatorView.frame) + 5, 60, 20);
//    // -- Description
//    CGSize descriptionSize = [self p_sizeForDescriptionLabel];
//    CGFloat descriptionHeight = 20;
//	if (self.descriptionExpanded) {
//		descriptionHeight = descriptionSize.height;
//	}
//    self.descriptionLabel.frame = CGRectMake(20, CGRectGetMinY(self.separatorView.frame) + CGRectGetHeight(self.separatorView.frame) + 5, descriptionSize.width, descriptionHeight);
//    
//    // -- Controls visibility
//	if ([self.descriptionLabel.text length]) {
//        self.descriptionLabel.hidden = NO;
//        if (self.descriptionExpanded) {
//            self.seeMoreButton.hidden = YES;
//        } else {
//            CGSize descriptionTextSize;
//            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
//                descriptionTextSize = [self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font  constrainedToSize:CGSizeMake(descriptionSize.width, MAXFLOAT)];
//            } else {
//                NSDictionary *textAttributes = @{NSFontAttributeName : self.descriptionLabel.font};
//                CGRect descriptionBoundingRect = [self.descriptionLabel.text boundingRectWithSize:CGSizeMake(descriptionSize.width, MAXFLOAT)
//                                                                                          options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:textAttributes
//                                                                                          context:nil];
//                descriptionTextSize = CGSizeMake(ceil(CGRectGetWidth(descriptionBoundingRect)), ceil(CGRectGetHeight(descriptionBoundingRect)));
//            }
//            if (descriptionTextSize.height > CGRectGetHeight(self.descriptionLabel.frame)) {
//                self.seeMoreButton.hidden = NO;
//            } else {
//                self.seeMoreButton.hidden = YES;
//            }
//        }
//    } else {
//        self.descriptionLabel.hidden = YES;
//        self.seeMoreButton.hidden = YES;
//    }
//	
//    if ([_title length]) {
//		self.titleLabel.hidden = NO;
//		self.separatorView.hidden = NO;
//	} else {
//		self.titleLabel.hidden = YES;
//		self.separatorView.hidden = YES;
//	}
//    
//    if (![_description length] && ![_title length]) {
//        _gradientLayer.hidden = YES;
//    } else {
//        _gradientLayer.hidden = NO;
//    }
//}




#pragma mark - Public methods

- (void)setOverlayVisible:(BOOL)visible animated:(BOOL)animated
{
	_animated = animated;
    self.visible = visible;
}

- (void)resetOverlayView
{
    self.descriptionExpanded = NO;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    CGRect frame = self.superview.frame;
    CGRect overlayFrame = CGRectZero;
    if (UIDeviceOrientationIsPortrait(orientation) || !UIDeviceOrientationIsLandscape(orientation)) {
        overlayFrame = CGRectMake(0, CGRectGetHeight(frame) - AGPhotoBrowserOverlayInitialHeight, CGRectGetWidth(frame), AGPhotoBrowserOverlayInitialHeight);
    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
        overlayFrame = CGRectMake(0, 0, AGPhotoBrowserOverlayInitialHeight, CGRectGetHeight(frame));
    } else {
        overlayFrame = CGRectMake(CGRectGetWidth(frame) - AGPhotoBrowserOverlayInitialHeight, 0, AGPhotoBrowserOverlayInitialHeight, CGRectGetHeight(frame));
    }
    
    [UIView animateWithDuration:0.15
                     animations:^(){
                         self.frame = overlayFrame;
                     }];
}


#pragma mark - Private methods

- (CGSize)p_sizeForDescriptionLabel
{
    CGFloat newDescriptionWidth;
    if (self.descriptionExpanded) {
        newDescriptionWidth = CGRectGetWidth(self.bounds) - 20 - CGRectGetWidth(self.actionButton.frame) - 10; // H:|-(==20)-[_descriptionLabel]-(==5)-[_actionButton]-(==5)-|
    } else {
        newDescriptionWidth = CGRectGetWidth(self.bounds) - 20 - 5 - CGRectGetWidth(self.seeMoreButton.frame) - CGRectGetWidth(self.actionButton.frame) - 5; // H:|-(==20)-[_descriptionLabel]-(==5)-[_seeMoreButton][_actionButton]-(==5)-|
    }
    
    CGSize descriptionSize;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        descriptionSize = [self.description sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(newDescriptionWidth, MAXFLOAT)];
    } else {
        NSDictionary *textAttributes = @{NSFontAttributeName : self.descriptionLabel.font};
        CGRect descriptionBoundingRect = [self.description boundingRectWithSize:CGSizeMake(newDescriptionWidth, MAXFLOAT)
                                                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:textAttributes
                                                                        context:nil];
        descriptionSize = CGSizeMake(ceil(CGRectGetWidth(descriptionBoundingRect)), ceil(CGRectGetHeight(descriptionBoundingRect)));
    }
    
    return descriptionSize;
}

#pragma mark - Buttons

- (void)p_actionButtonTapped:(UIButton *)sender
{
	if ([self.delegate respondsToSelector:@selector(sharingView:didTapOnActionButton:)]) {
		[self.delegate sharingView:self didTapOnActionButton:sender];
	}
}

- (void)p_seeMoreButtonTapped:(UIButton *)sender
{
	if ([self.delegate respondsToSelector:@selector(sharingView:didTapOnSeeMoreButton:)]) {
		[self.delegate sharingView:self didTapOnSeeMoreButton:sender];
	}
    
    self.descriptionExpanded = YES;
    
    CGSize newDescriptionSize = [self p_sizeForDescriptionLabel];
    
    CGRect currentOverlayFrame = self.frame;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation) || !UIDeviceOrientationIsLandscape(orientation)) {
        int newSharingHeight = CGRectGetHeight(currentOverlayFrame) - 20 + newDescriptionSize.height;
        currentOverlayFrame.size.height = newSharingHeight;
        currentOverlayFrame.origin.y -= (newSharingHeight - CGRectGetHeight(self.bounds));
    } else if (orientation == UIDeviceOrientationLandscapeLeft) {
        int newSharingWidth = CGRectGetWidth(currentOverlayFrame) - 20 + newDescriptionSize.height;
        currentOverlayFrame.size.width = newSharingWidth;
    } else {
        int newSharingWidth = CGRectGetWidth(currentOverlayFrame) - 20 + newDescriptionSize.height;
        currentOverlayFrame.origin.x -= (newSharingWidth - CGRectGetWidth(currentOverlayFrame));
        currentOverlayFrame.size.width = newSharingWidth;
    }
    
    [UIView animateWithDuration:AGPhotoBrowserAnimationDuration
                     animations:^(){
                         self.frame = currentOverlayFrame;
                     }];
    
//    [self.sharingView addGestureRecognizer:self.tapGesture];
}


#pragma mark - Recognizers

- (void)p_tapGestureTapped:(UITapGestureRecognizer *)recognizer
{
	self.visible = !self.visible;
//	[self resetOverlayView];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if ([self.sharingView pointInside:point withEvent:event]) {
        return self.sharingView;
    }
    return nil;
}


#pragma mark - Setters

- (void)setVisible:(BOOL)visible
{
	_visible = visible;
	
	CGFloat newAlpha = _visible ? 1. : 0.;
	[UIView animateWithDuration:AGPhotoBrowserAnimationDuration
					 animations:^(){
						 self.alpha = newAlpha;
					 }];
}

- (void)setTitle:(NSString *)title
{
	_title = title;
	
	self.titleLabel.text = _title.length ? _title : @"";
}

- (void)setDescription:(NSString *)description
{
	_description = description;
	
	self.descriptionLabel.text = _description.length ? _description : @"";
}


#pragma mark - Getters

- (AGPhotoBrowserGradientView *)sharingView
{
	if (!_sharingView) {
		_sharingView = [[AGPhotoBrowserGradientView alloc] initWithFrame:CGRectZero];
		_sharingView.translatesAutoresizingMaskIntoConstraints = NO;
		_sharingView.backgroundColor = [UIColor clearColor];

		_sharingView.layer.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
	}
	
	return _sharingView;
}

- (UILabel *)titleLabel
{
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_titleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:0.9];
		_titleLabel.font = [UIFont boldSystemFontOfSize:14];
		_titleLabel.backgroundColor = [UIColor clearColor];
	}
	
	return _titleLabel;
}

- (UIView *)separatorView
{
	if (!_separatorView) {
		_separatorView = [[UIView alloc] initWithFrame:CGRectZero];
		_separatorView.translatesAutoresizingMaskIntoConstraints = NO;
		_separatorView.backgroundColor = [UIColor lightGrayColor];
        _separatorView.hidden = YES;
	}
	
	return _separatorView;
}

- (UILabel *)descriptionLabel
{
	if (!_descriptionLabel) {
		_descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_descriptionLabel.textColor = [UIColor colorWithWhite:0.9 alpha:0.9];
		_descriptionLabel.font = [UIFont systemFontOfSize:13];
		_descriptionLabel.backgroundColor = [UIColor clearColor];
		_descriptionLabel.numberOfLines = 0;
	}
	
	return _descriptionLabel;
}

- (UIButton *)seeMoreButton
{
	if (!_seeMoreButton) {
		_seeMoreButton = [[UIButton alloc] initWithFrame:CGRectZero];
		[_seeMoreButton setTitle:NSLocalizedString(@"See More", @"Title for See more button") forState:UIControlStateNormal];
		[_seeMoreButton setBackgroundColor:[UIColor clearColor]];
		[_seeMoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		_seeMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        _seeMoreButton.hidden = YES;
		
		[_seeMoreButton addTarget:self action:@selector(p_seeMoreButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _seeMoreButton;
}

- (UIButton *)actionButton
{
	if (!_actionButton) {
		_actionButton = [[UIButton alloc] initWithFrame:CGRectZero];
		[_actionButton setTitle:NSLocalizedString(@"● ● ●", @"Title for Action button") forState:UIControlStateNormal];
		[_actionButton setBackgroundColor:[UIColor clearColor]];
		[_actionButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9] forState:UIControlStateNormal];
		[_actionButton setTitleColor:[UIColor colorWithWhite:0.9 alpha:0.9] forState:UIControlStateHighlighted];
		[_actionButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        
		[_actionButton addTarget:self action:@selector(p_actionButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _actionButton;
}

- (UITapGestureRecognizer *)tapGesture
{
	if (!_tapGesture) {
		_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_tapGestureTapped:)];
		_tapGesture.numberOfTouchesRequired = 1;
	}
	
	return _tapGesture;
}

@end
