//
//  LGCustomAcitivityIndicator.m
//  localsgowild
//
//  Created by Vladimir Milichenko on 3/14/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPCustomAcitivityIndicator.h"

#define STANDART_LINE_WIDTH 7.5f;

@implementation SPCustomAcitivityIndicator

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.startColor = [UIColor whiteColor];
        self.endColor = [UIColor blackColor];
        self.isInfinite = YES;
        self.isRotating = NO;
        self.hidesWhenStopped = YES;
        
        if (self.hidesWhenStopped)
        {
            self.hidden = YES;
        }
    }
    
    return self;
}

- (id)init
{
    self = [self initWithFrame:CGRectMake(0.0f, 0.0f, INDICATOR_STANDART_SIZE, INDICATOR_STANDART_SIZE)
                    isInfinite:YES
                withStartColor:[UIColor whiteColor]
                      endColor:[UIColor blackColor]];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame isInfinite:YES withStartColor:[UIColor whiteColor] endColor:[UIColor blackColor]];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame isInfinite:(BOOL)isInfinite withStartColor:(UIColor *)startColor endColor:(UIColor *)endColor
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.startColor = startColor;
        self.endColor = endColor;
        self.isInfinite = isInfinite;
        self.isRotating = NO;
        self.hidesWhenStopped = YES;
        
        if (self.isInfinite)
        {
            [self startRotating];
        }
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(rect.size.width / 2.0f, rect.size.height / 2.0f);
    CGFloat minSize = MIN(rect.size.width, rect.size.height);
    
    CGFloat sizePercents = minSize / INDICATOR_STANDART_SIZE;
    
    CGFloat lineWidth = sizePercents * STANDART_LINE_WIDTH;
    CGFloat radius = (minSize - lineWidth) / 2.0f;
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, center.x, center.y);
    CGContextRotateCTM(ctx, -M_PI * 0.5);
    
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGFloat startRed = 0.0f;
    CGFloat startGreen = 0.0f;
    CGFloat startBlue = 0.0f;
    CGFloat startAlpha = 0.0f;
    
    [self.startColor getRed:&startRed green:&startGreen blue:&startBlue alpha:&startAlpha];
    
    CGFloat endRed = 0.0f;
    CGFloat endGreen = 0.0f;
    CGFloat endBlue = 0.0f;
    CGFloat endAlpha = 0.0f;
    
    [self.endColor getRed:&endRed green:&endGreen blue:&endBlue alpha:&endAlpha];
    
    CGFloat redDiff = endRed - startRed;
    CGFloat greenDiff = endGreen - startGreen;
    CGFloat blueDiff = endBlue - startBlue;
    CGFloat alphaDiff = endAlpha - startAlpha;
    
    CGFloat endAngle = M_PI * 2.0f;
    
    CGContextBeginPath(ctx);
    
    CGFloat currentPercent = 0.0f;
    CGFloat currentAngle = 0.0f;
    
    CGFloat fullPercents = self.isInfinite ? 1.0f : self.value;
    
    while (currentPercent < fullPercents)
    {
        CGContextAddArc(ctx, 0.0f, 0.0f, radius, currentAngle, endAngle * currentPercent, 0);
        
        CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:startRed + (redDiff * currentPercent)
                                                              green:startGreen + (greenDiff * currentPercent)
                                                               blue:startBlue + (blueDiff * currentPercent)
                                                              alpha:startAlpha + (alphaDiff * currentPercent)].CGColor);
        CGContextStrokePath(ctx);
        
        currentAngle = endAngle * currentPercent;
        currentPercent += 0.025f;
    }

    CGContextRestoreGState(ctx);
}

#pragma mark - Property implementations

- (void)setValue:(CGFloat)value
{
    value = value < 0.0 ? 0.0f : value;
    value = value > 1.0 ? 1.0f : value;
    
    _value = value;
    
    [self setNeedsDisplay];
}

#pragma mark - Public methods

- (void)startRotating
{
    if (!self.isRotating)
    {
        if (self.hidden)
        {
            self.hidden = NO;
        }
        
        [self rotateIndicator];
        
        self.isRotating = YES;
    }
}

- (void)rotateIndicator
{
    __weak SPCustomAcitivityIndicator *weakSelf = self;
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [weakSelf setTransform:CGAffineTransformRotate(weakSelf.transform, M_PI_2)];
    } completion:^(BOOL finished) {
        if (finished && weakSelf.isRotating)
        {
            [weakSelf rotateIndicator];
        }
    }];
}

- (void)stopRotating
{
    self.isRotating = NO;
    
    if (self.hidesWhenStopped)
    {
        self.hidden = YES;
    }
}

@end
