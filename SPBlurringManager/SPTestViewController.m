//
//  SPTestViewController.m
//  SPBlurringManager
//
//  Created by Vladimir Milichenko on 7/11/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPTestViewController.h"
#import "SPBlurringManager.h"

@interface SPTestViewController ()

@end

@implementation SPTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[SPBlurringManager sharedManager] startAnimationWithBackgroundColor:[UIColor blackColor]
                                                                    text:@"Blur test"
                                                            textFontName:@"Helvetica"
                                                              fullScreen:YES
                                                                 forView:self.view aboveView:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
