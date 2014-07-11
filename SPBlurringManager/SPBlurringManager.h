//
//  LGBlurringManager.h
//  localsgowild
//
//  Created by Vladimir Milichenko on 2/4/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

@import Foundation;

@class SPRemoveSignalView;

@interface SPBlurringManager : NSObject

@property (nonatomic, strong) SPRemoveSignalView *loadingView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, assign) BOOL isRunning;
@property (nonatomic, assign) BOOL isNonStop;

+ (SPBlurringManager *)sharedManager;

- (void)startAnimationWithBackgroundColor:(UIColor *)backgroundColor
                                     text:(NSString *)text
                             textFontName:(NSString *)fontName
                               fullScreen:(BOOL)isFullScreen
                                  forView:(UIView *)view
                                aboveView:(UIView *)aboveView;
- (void)stopAnimation;

@end
