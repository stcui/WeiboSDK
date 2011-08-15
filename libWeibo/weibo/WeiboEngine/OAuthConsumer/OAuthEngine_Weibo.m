//
//  OAuthEngine_Weibo.m
//  SinaWeiboOAuthDemo
//
//  Created by stcui on 11-6-14.
//  Copyright 2011年 stcui. All rights reserved.
//

#import "OAuthEngine_Weibo.h"
#import "OAToken.h"
#import "OAMutableURLRequest.h"

@implementation OAuthEngine (Weibo)

//This generates a URL request that can be passed to a UIWebView. It will open a page in which the user must enter their Twitter creds to validate
- (NSURLRequest *) authorizeURLRequestWithLogin:(NSString*)login password:(NSString*)password {
	if (!_requestToken.key && _requestToken.secret) return nil;	// we need a valid request token to generate the URL
	
    NSURL *authorizeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?userId=%@&passwd=%@&oauth_token=%@&oauth_callback=json",
                                                self.authorizeURL,                                               
                                                [login stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                [password stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                                _requestToken.key]];
                                                
	OAMutableURLRequest			*request = [[[OAMutableURLRequest alloc] initWithURL: authorizeURL consumer: nil token: nil realm: nil signatureProvider: nil] autorelease];

//    [request setOAuthParameterName:@"oauth_callback" withValue:@"json"];
//    [request setOAuthParameterName:@"username" withValue:login];
//    [request setOAuthParameterName:@"password" withValue:@"password"];
//	
//	[request setParameters: [NSArray arrayWithObject: [[[OARequestParameter alloc] initWithName: @"oauth_token" value: _requestToken.key] autorelease]]];
    
	return request;
}

@end
