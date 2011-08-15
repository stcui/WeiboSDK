//
//  LoginView.m
//  SinaWeiboOAuthDemo
//
//  Created by stcui on 11-6-14.
//  Copyright 2011年 stcui. All rights reserved.
//

#import "OALoginView.h"


@implementation OALoginView
@synthesize loginFeild = _loginField;
@synthesize passwordField = _passwordField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIFont *font = [UIFont systemFontOfSize:18];
        UIColor *clearColor = [UIColor clearColor];
        self.backgroundColor = [UIColor colorWithRed:0.882 green:0.914 blue:0.918 alpha:1.0];
        
        // Add Logo
        UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WeiboLogo"]];
        CGRect logoFrame = logoView.frame;
        logoFrame.origin = CGPointMake(34, 20);
        logoView.frame = logoFrame;
        logoView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:logoView];
        [logoView release];
        
        // Add Tip
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(82, 35, 210, 20)];
        titleLabel.backgroundColor = clearColor;
        titleLabel.text = NSLocalizedString(@"请用新浪微博帐号登录", @"新浪微博登录提示");
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = [UIColor colorWithRed:0.047 green:0.227 blue:0.349 alpha:1.0];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:titleLabel];
        [titleLabel release];
        
        // Add Text Input View
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"LoginBg"] stretchableImageWithLeftCapWidth:50 topCapHeight:0]];
        bgView.center = CGPointMake(frame.size.width / 2, 117);
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:bgView];
        [bgView release];
        
        // Add Login Title
        UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 87, 45, 20)];
        loginLabel.backgroundColor = clearColor;
        loginLabel.font = font;
        loginLabel.text = NSLocalizedString(@"帐号", @"帐号");
        [self addSubview:loginLabel];
        [loginLabel release];
        
        // Add Password Title
        UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 132, 45, 20)];
        passwordLabel.backgroundColor = clearColor;
        passwordLabel.font = font;
        passwordLabel.text = NSLocalizedString(@"密码", @"密码");
        [self addSubview:passwordLabel];
        [passwordLabel release];
        
        
        // Add TextFields        
        _loginField = [[UITextField alloc] initWithFrame:CGRectMake(77, 87, 225, 21)];
        _loginField.font = font;
        _loginField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _loginField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _loginField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _loginField.keyboardType = UIKeyboardTypeEmailAddress;
        _loginField.returnKeyType = UIReturnKeyNext;
        
        _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(77, 130, 225, 21)];
        _passwordField.font = font;
        _passwordField.secureTextEntry = YES;
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        
        [self addSubview:_loginField];
        [self addSubview:_passwordField];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    _loginField.delegate = nil;
    _passwordField.delegate = nil;
    [_loginField release];
    [_passwordField release];
    
    [super dealloc];
}

@end
