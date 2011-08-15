//
//  OAuthController.m
//  WeiboPad
//
//  Created by junmin liu on 10-10-5.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "OAuthController.h"
#import "OAuthEngine.h"
#import "OALoginView.h"
#import "OADataFetcher.h"
#import "OAMutableURLRequest.h"
#import "OAuthEngine_Weibo.h"
#import "JSONKit.h"

#define kSpinnerTag 1010

@interface OAuthController ()
@property (nonatomic, readwrite) UIInterfaceOrientation orientation;

- (id) initWithEngine: (OAuthEngine *) engine andOrientation:(UIInterfaceOrientation)theOrientation;
- (void) gotPin: (NSString *) pin;
@end


@interface DummyClassForProvidingSetDataDetectorTypesMethod
- (void) setDataDetectorTypes: (int) types;
- (void) setDetectsPhoneNumbers: (BOOL) detects;
@end

@interface NSString (OAuth)
- (BOOL) oauth_isNumeric;
@end

@implementation NSString (OAuth)
- (BOOL) oauth_isNumeric {
	const char				*raw = (const char *) [self UTF8String];
	
	for (int i = 0; i < strlen(raw); i++) {
		if (raw[i] < '0' || raw[i] > '9') return NO;
	}
	return YES;
}
@end

@implementation OAuthController
@synthesize engine = _engine, delegate = _delegate, navigationBar = _navBar, orientation = _orientation;


- (void) dealloc {
	
    [_loginView release];
    
	self.view = nil;
	self.engine = nil;
	[super dealloc];
}

+ (OAuthController *) controllerToEnterCredentialsWithEngine: (OAuthEngine *) engine delegate: (id <OAuthControllerDelegate>) delegate forOrientation: (UIInterfaceOrientation)theOrientation {
	if (![self credentialEntryRequiredWithEngine: engine]) return nil;			//not needed
	
	OAuthController					*controller = [[[OAuthController alloc] initWithEngine: engine andOrientation: theOrientation] autorelease];
	
	controller.delegate = delegate;
	return controller;
}

+ (OAuthController *) controllerToEnterCredentialsWithEngine: (OAuthEngine *) engine delegate: (id <OAuthControllerDelegate>) delegate {
	return [OAuthController controllerToEnterCredentialsWithEngine: engine delegate: delegate forOrientation: UIInterfaceOrientationPortrait];
}


+ (BOOL) credentialEntryRequiredWithEngine: (OAuthEngine *) engine {
	return ![engine isAuthorized];
}


- (id) initWithEngine: (OAuthEngine *) engine andOrientation:(UIInterfaceOrientation)theOrientation {
    self = [super init];
	if (self) {
		self.engine = engine;
		if (!engine.OAuthSetup) [_engine requestRequestToken];
		self.orientation = theOrientation;
		_firstLoad = YES;
	}
	return self;
}

//=============================================================================================================================
#pragma mark Actions
- (void) denied {
	if ([_delegate respondsToSelector: @selector(OAuthControllerFailed:)]) [_delegate OAuthControllerFailed: self];
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 1.0];
}

- (void) gotPin: (NSString *) pin {
	_engine.pin = pin;
	[_engine requestAccessToken];
	
	if ([_delegate respondsToSelector: @selector(OAuthController:authenticatedWithUsername:)]) [_delegate OAuthController: self authenticatedWithUsername: _engine.username];
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 1.0];
}

- (void) cancel: (id) sender {
	if ([_delegate respondsToSelector: @selector(OAuthControllerCanceled:)]) [_delegate OAuthControllerCanceled: self];
	[self performSelector: @selector(dismissModalViewControllerAnimated:) withObject: (id) kCFBooleanTrue afterDelay: 0.0];
}

//=============================================================================================================================
#pragma mark View Controller Stuff
- (void) loadView {
	[super loadView];
	self.view = [[[UIView alloc] initWithFrame: ApplicationFrame(self.orientation)] autorelease];
	_navBar = [[[UINavigationBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)] autorelease];
	
	_navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	CGRect frame = ApplicationFrame(self.orientation);
	frame.origin.y = 44;
	frame.size.height -= 44;
    
    // Add Login view
    _loginView = [[OALoginView alloc] initWithFrame:frame];
    _loginView.loginFeild.delegate = self;
    _loginView.passwordField.delegate = self;
    [self.view addSubview:_loginView];
   
	[self.view addSubview: _navBar];
	
	_blockerView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 200, 60)] autorelease];
	_blockerView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.8];
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
	_blockerView.alpha = 0.0;
	_blockerView.clipsToBounds = YES;
	if ([_blockerView.layer respondsToSelector: @selector(setCornerRadius:)]) [(id) _blockerView.layer setCornerRadius: 10];
	
	UILabel								*label = [[[UILabel alloc] initWithFrame: CGRectMake(0, 5, _blockerView.bounds.size.width, 15)] autorelease];
	label.text = NSLocalizedString(@"Please Wait…", nil);
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont boldSystemFontOfSize: 15];
	[_blockerView addSubview: label];
    
	UIActivityIndicatorView				*spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
	spinner.tag = kSpinnerTag;
	spinner.center = CGPointMake(_blockerView.bounds.size.width / 2, _blockerView.bounds.size.height / 2 + 10);
	[_blockerView addSubview: spinner];
	[self.view addSubview: _blockerView];
	
	UINavigationItem				*navItem = [[[UINavigationItem alloc] initWithTitle: NSLocalizedString(@"Sina Weibo Info", nil)] autorelease];
	navItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(cancel:)] autorelease];
	
	[_navBar pushNavigationItem: navItem animated: NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void) didRotateFromInterfaceOrientation: (UIInterfaceOrientation) fromInterfaceOrientation {
	self.orientation = self.interfaceOrientation;
	NSLog(@"orientation:%d", self.interfaceOrientation);
	CGRect frame = ApplicationFrame(self.orientation);
	frame.origin.y = 44;
	frame.size.height -= 44;
	_loginView.frame = frame;
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
}

//=============================================================================================================================
- (void)singinWithLogin:(NSString*)login password:(NSString*)password {
    _blockerView.alpha = 1.0;
    [(UIActivityIndicatorView*)[_blockerView viewWithTag:kSpinnerTag] startAnimating];
    
    OAMutableURLRequest *request = [_engine authorizeURLRequestWithLogin:login password:password];
    OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
    [fetcher fetchDataWithRequest: request delegate: self didFinishSelector: @selector(setAccessToken:withData:) didFailSelector: @selector(oauthTicketFailed:data:)];
}

#pragma mark - OADataFetcher Delegate
- (void) setAccessToken: (OAServiceTicket *) ticket withData: (NSData *) data {
    NSString *result = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
    NSDictionary *response = [result objectFromJSONString];
    
    NSString *localizedErrorReason = nil;
    if ([response valueForKey:@"error"]) {
        NSArray *errorArr = [[response valueForKey:@"error"] componentsSeparatedByString:@":"];
        localizedErrorReason = NSLocalizedString([errorArr lastObject], @"Error Reason");
        NSLog(@"failed: %@", localizedErrorReason);
        [self denied];
    } else {
        [self gotPin:[response valueForKey:@"oauth_verifier"]];
    }
    NSLog(@"url: %@, ticket: %@, result: %@", ticket.request.URL, ticket, result);
}

- (void) oauthTicketFailed: (OAServiceTicket *) ticket data: (NSData *) data {
    [self denied];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _loginView.loginFeild) {
        [_loginView.passwordField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self singinWithLogin:_loginView.loginFeild.text password:_loginView.passwordField.text];
    }
    return YES;    
}
@end
