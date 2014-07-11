//
//  LGCustomAcitivityIndicator.h
//  localsgowild
//
//  Created by Vladimir Milichenko on 3/14/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

@import UIKit;

#define INDICATOR_STANDART_SIZE 56.0f

@interface SPCustomAcitivityIndicator : UIView

@property (nonatomic, assign) CGFloat value;

@property (nonatomic, assign) BOOL isInfinite;
@property (nonatomic, assign) BOOL isRotating;
@property (nonatomic, assign) BOOL hidesWhenStopped;

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

- (id)initWithFrame:(CGRect)frame isInfinite:(BOOL)isInfinite withStartColor:(UIColor *)startColor endColor:(UIColor *)endColor;

- (void)startRotating;
- (void)stopRotating;

@end
