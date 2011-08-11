//
//  StatusView.h
//  SinaWeiboOAuthDemo
//
//  Created by stcui on 11-6-15.
//  Copyright 2011年 stcui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"


@interface StatusView : UIView {
    Status *_status;
}
@property (nonatomic, retain) Status *status;

@end
