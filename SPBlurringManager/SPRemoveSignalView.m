//
//  LGRemoveSignalView.m
//  localsgowild
//
//  Created by Arakelyan on 4/23/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

#import "SPRemoveSignalView.h"

@implementation SPRemoveSignalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
    
    }
    
    return self;
}


- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    [self.delegate removeSignalViewRemovedFromSuperview];
}

@end
