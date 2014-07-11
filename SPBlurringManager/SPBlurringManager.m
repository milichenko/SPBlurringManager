//
//  LGBlurringManager.m
//  localsgowild
//
//  Created by Vladimir Milichenko on 2/4/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPBlurringManager.h"
#import "SPRemoveSignalView.h"
#import "UIImage+ImageEffects.h"
#import "SPCustomAcitivityIndicator.h"

//#import "LGAppearanceManager.h"
//#import "UIDeviceHardware.h"
//#import "UIImage+ImageEffects.h"
//#import "LGCustomAcitivityIndicator.h"

#define COMPONENTS_INDENT   8.0f
#define ANIMATION_DURATION  0.4f
#define VISIBLE_ALPHA       0.8f


static NSString *const SuperviewChangeNotification = @"loadingView.superview";

@interface SPBlurringManager () <SPRemoveSignalViewDelegate>

@property (nonatomic, strong) SPCustomAcitivityIndicator *activityIndicator;
@property (nonatomic, strong) UIImageView *bluredImageView;

@property (nonatomic, assign) CGFloat visibleAlpha;

@end

static SPBlurringManager *sharedManager = nil;

@implementation SPBlurringManager

+ (SPBlurringManager *)sharedManager
{
    if (!sharedManager)
    {
        sharedManager = [[SPBlurringManager alloc] init];
    }
    
    return sharedManager;
}

- (id)init
{
    if ((self = [super init]))
    {
        _loadingView = [[SPRemoveSignalView alloc] init];
        _loadingView.alpha = 0.0f;
        
        _activityIndicator = [[SPCustomAcitivityIndicator alloc] initWithFrame:CGRectMake(0.0f, 0.0f, INDICATOR_STANDART_SIZE, INDICATOR_STANDART_SIZE)
                                                                    isInfinite:YES
                                                                withStartColor:[UIColor blackColor]
                                                                      endColor:[UIColor whiteColor]];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.alpha = 1.0f;
        
        _bluredImageView = [[UIImageView alloc] init];
        
        _isRunning = NO;
        _isNonStop = NO;
        _visibleAlpha = VISIBLE_ALPHA;
        
        [_loadingView addSubview:_textLabel];
        [_loadingView addSubview:_bluredImageView];
        [_loadingView addSubview:_activityIndicator];
        
        _loadingView.delegate = self;
    }
    
    return self;
}

- (void)startAnimationWithBackgroundColor:(UIColor *)backgroundColor
                                     text:(NSString *)text
                             textFontName:(NSString *)fontName
                               fullScreen:(BOOL)isFullScreen
                                  forView:(UIView *)view
                                aboveView:(UIView *)aboveView
{
    if (!self.isRunning)
    {
        if (aboveView)
        {
            [view insertSubview:self.loadingView aboveSubview:aboveView];
        }
        else
        {
            [view addSubview:self.loadingView];
        }
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        
        if (isFullScreen)
        {
            [self.loadingView setFrame:screenRect];
            
            _activityIndicator.center = CGPointMake(screenRect.size.width / 2, screenRect.size.height / 2);
            
            if (text)
            {
                UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:22.0f];
                CGFloat labelWidth = self.loadingView.frame.size.width - (2 * COMPONENTS_INDENT);
                
                CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:labelFont}];
                
                _textLabel.frame = CGRectMake(COMPONENTS_INDENT, _activityIndicator.frame.origin.y - textSize.height - COMPONENTS_INDENT, labelWidth, textSize.height);
                _textLabel.numberOfLines = 10;
                _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                _textLabel.textAlignment = NSTextAlignmentCenter;
                _textLabel.font = labelFont;
                _textLabel.textColor = [UIColor whiteColor];
                _textLabel.text = text;
                _textLabel.backgroundColor = [UIColor clearColor];
            }
        }
        else
        {
            [self.loadingView setFrame:CGRectMake(screenRect.size.width / 2, screenRect.size.height / 2, _activityIndicator.frame.size.width, _activityIndicator.frame.size.height)];
        }
        
        self.bluredImageView.frame = self.loadingView.frame;
        self.bluredImageView.hidden = YES;
        
        if (_textLabel)
        {
            [self.loadingView bringSubviewToFront:_textLabel];
        }
        
        self.loadingView.backgroundColor = backgroundColor;
        
        self.visibleAlpha = 1.0f;
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, 0.2);
        
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        UIColor *tintColor = [UIColor colorWithWhite:0.21f alpha:0.3f];
        
        UIImage *blurringImage = [viewImage applyBlurWithRadius:5.0f
                                                      tintColor:tintColor saturationDeltaFactor:1.5f
                                                      maskImage:nil];
        
        self.bluredImageView.image = blurringImage;
        self.bluredImageView.hidden = NO;
        
        [self performAnimating];
    }
}

- (void)stopAnimation
{
    if (self.isRunning)
    {
        [self.activityIndicator stopRotating];
        
        __weak SPBlurringManager *weakSelf = self;
        
        if (_activityIndicator.hidesWhenStopped)
        {
            [UIView animateWithDuration:ANIMATION_DURATION animations:^(void) {
                weakSelf.loadingView.alpha = 0.0f;
            }];
        }
        
        [UIView animateWithDuration:ANIMATION_DURATION animations:^(void) {
            weakSelf.loadingView.alpha = 0.0f;
        }];
        
        self.loadingView.userInteractionEnabled = NO;
        self.bluredImageView.hidden = YES;
        self.isRunning = NO;
        self.isNonStop = NO;
        
        [self.loadingView removeFromSuperview];
    }
}

#pragma mark - Private methods

- (void)performAnimating
{
    self.loadingView.userInteractionEnabled = YES;
    [self.activityIndicator startRotating];
    
    __weak SPBlurringManager *weakSelf = self;
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^(void) {
        weakSelf.loadingView.alpha = self.visibleAlpha;
    }];
    
    self.loadingView.hidden = NO;
    self.isRunning = YES;
}


#pragma mark - LGRemoveSignalViewDelegate

- (void)removeSignalViewRemovedFromSuperview
{
    [self stopAnimation];
}

@end
