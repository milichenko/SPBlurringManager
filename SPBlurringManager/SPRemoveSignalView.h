//
//  LGRemoveSignalView.h
//  localsgowild
//
//  Created by Arakelyan on 4/23/14.
//  Copyright (c) 2014 massinteractiveserviceslimited. All rights reserved.
//

@import UIKit;

@protocol SPRemoveSignalViewDelegate <NSObject>

- (void)removeSignalViewRemovedFromSuperview;

@end


@interface SPRemoveSignalView : UIView

@property (nonatomic, weak) id<SPRemoveSignalViewDelegate> delegate;

@end
