//
//  SwizzleLoader.m
//  InfiniteScroll
//
//  Created by Ion Postolachi on 12/21/19.
//  Copyright © 2019 Ion Postolachi. All rights reserved.
//

#import "SwizzleLoader.h"
#import <UIKit/UIKit.h>
#import <POSInfiniteScroll/POSInfiniteScroll-Swift.h>

@implementation SwizzleLoader
    + (void)load {
        [UIScrollView swizzleContentOffset];
    }
@end
