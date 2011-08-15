//
//  OAuthEngine_Weibo.h
//  SinaWeiboOAuthDemo
//
//  Created by stcui on 11-6-14.
//  Copyright 2011年 stcui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthEngine.h"

@class OAMutableURLRequest;
@interface OAuthEngine (Weibo)
    
- (OAMutableURLRequest *) authorizeURLRequestWithLogin:(NSString*)login password:(NSString*)password;

@end
