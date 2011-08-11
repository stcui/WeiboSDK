//
//  LoginView.h
//  SinaWeiboOAuthDemo
//
//  Created by stcui on 11-6-14.
//  Copyright 2011年 stcui. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OALoginView : UIView {
    UITextField *_loginField;
    UITextField *_passwordField;
}
@property (nonatomic, readonly) UITextField *loginFeild;
@property (nonatomic, readonly) UITextField *passwordField;


@end
