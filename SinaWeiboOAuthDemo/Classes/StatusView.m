//
//  StatusView.m
//  SinaWeiboOAuthDemo
//
//  Created by stcui on 11-6-15.
//  Copyright 2011年 stcui. All rights reserved.
//

#import "StatusView.h"

#define kImageWidth 54
#define kImageHeight 54
#define kImageInset 2
#define kHSpacingToBg 5

#define kContentPaddingTop 9
#define kContentPaddingBottom 9
#define kContentPaddingLeft 18
#define kContentPaddingRight 9

#define kVSpacing 8
#define kIndent 2
#define kShadowOffset 1.0
#define kShadowBlur 3.0

#define kUserNameFont [UIFont boldSystemFontOfSize:15]
#define kDateColor [UIColor colorWithRed:.62 green:.63 blue:.64 alpha:1.0]
#define kDateFont [UIFont systemFontOfSize:14] 
#define kDetailFont [UIFont systemFontOfSize:16]

#define kSeplineIndent -3
#define kSeplineRightPadding 7

@implementation StatusView
@synthesize status = _status;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.contentMode = UIViewContentModeRedraw;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.backgroundColor = newSuperview.backgroundColor;
}

- (void)setStatus:(Status *)status {
    if (_status != status) {
        [_status release];
        _status = [status retain];
        [self setNeedsDisplay];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat x = 0.0, y = 0.0;

    // Draw Profile Imagee
    UIGraphicsBeginImageContext(CGSizeMake(kImageWidth + 2 * (kShadowOffset + kShadowBlur), kImageHeight + 2 * (kShadowOffset + kShadowBlur)));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx); // Turn on Shadow Rendering
    CGContextSetShadow(ctx,CGSizeMake(kShadowOffset, kShadowOffset), kShadowBlur);
    CGRect profileImageBorder = CGRectMake(kShadowBlur - kShadowOffset, kShadowBlur - kShadowOffset, kImageWidth, kImageHeight);
    [[UIColor whiteColor] set];
    UIRectFill(profileImageBorder);
    CGContextRestoreGState(ctx); // Turn off Shadow Rendering
    
    // Draw Avatar
    UIImage *avatar = [UIImage imageNamed:@"Avatar"];
    [avatar drawInRect:CGRectInset(profileImageBorder, kImageInset, kImageInset)];
    
    // Get Rendered Avatar Image
    UIImage *profileImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Draw Rendered Avatar
    [profileImage drawAtPoint:CGPointMake( kShadowOffset - kShadowBlur + 1 , kShadowOffset - kShadowBlur + 1)];
    
    
    ctx = UIGraphicsGetCurrentContext();

    if (_status.user.verified) {
        // Draw Verified Icon
        CGContextSaveGState(ctx);
        CGContextSetShadow(ctx, CGSizeMake(kShadowOffset, kShadowOffset), kShadowBlur);
        UIImage *verifiedIcon = [UIImage imageNamed:@"Verified"];
        [verifiedIcon drawAtPoint:
         CGPointMake(CGRectGetMaxX(profileImageBorder) - kShadowBlur - kShadowOffset - verifiedIcon.size.width / 2, CGRectGetMaxY(profileImageBorder) - kShadowBlur - kShadowOffset - verifiedIcon.size.height / 2)];
        CGContextRestoreGState(ctx);
    }
    
    // Draw Bubble Background
    UIImage *bubbleBg = [[UIImage imageNamed:@"WeiboBg"] stretchableImageWithLeftCapWidth:0 topCapHeight:30];
    [bubbleBg drawInRect:CGRectMake(kImageWidth + kHSpacingToBg, 0, self.frame.size.width - kImageWidth - kHSpacingToBg, self.frame.size.height)];
    x = kContentPaddingLeft + kImageWidth + kHSpacingToBg;
    y += kContentPaddingTop;
    
    // Draw Username
    CGSize nameSize = [_status.user.name drawAtPoint:CGPointMake(x, y) withFont:kUserNameFont];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"YY-MM-dd"];
    NSString *pubDate = [dateFormatter stringFromDate: [NSDate dateWithTimeIntervalSince1970: _status.createdAt]];
    CGSize pubDateSize = [pubDate sizeWithFont:kDateFont];
    CGContextSaveGState(ctx);
    [kDateColor set];
    CGSize dateSize = [pubDate drawAtPoint:CGPointMake(self.frame.size.width - kContentPaddingRight - pubDateSize.width, y) withFont:kDateFont];
    CGContextRestoreGState(ctx);
 
    if (_status.thumbnailPic && [_status.thumbnailPic length] > 0) {
        UIImage *hasImageIcon = [UIImage imageNamed:@"HasImage"];
        [hasImageIcon drawAtPoint:CGPointMake(self.frame.size.width - kContentPaddingRight - dateSize.width - kIndent - hasImageIcon.size.width, y + [kDetailFont ascender] - [kDetailFont capHeight] )];
    }
    
    y += (kVSpacing + nameSize.height);
    // Draw Status Text
    CGSize textSize = [_status.text drawInRect:CGRectMake(x, y, self.frame.size.width - kContentPaddingRight - x, CGFLOAT_MAX)
                                      withFont:kDetailFont
                                 lineBreakMode:UILineBreakModeCharacterWrap];
    y += (kVSpacing + textSize.height);
    if (_status.retweetedStatus) {
        CGContextSetRGBStrokeColor(ctx, 0.8, 0.82, 0.878, 1.0);
        CGContextStrokeLineSegments(ctx, (const CGPoint[]){CGPointMake(x+kSeplineIndent, y), 
            CGPointMake(self.frame.size.width - kSeplineRightPadding, y)}, 2);
        y += kVSpacing;
        
        NSString *reName = [NSString stringWithFormat:@"%@:", _status.retweetedStatus.user.name];
        CGSize retweetNameSize = [reName drawAtPoint:CGPointMake(x + kIndent, y)
                                            withFont:kUserNameFont];
        [_status.retweetedStatus.text drawAtPoint:CGPointMake(x + retweetNameSize.width + kIndent, y)
                                         forWidth:self.frame.size.width - x - retweetNameSize.width - kIndent
                                         withFont:kDetailFont
                                         fontSize:[kDetailFont pointSize]
                                    lineBreakMode: UILineBreakModeTailTruncation
                               baselineAdjustment:UIBaselineAdjustmentNone];
        
    }
    
//    CGSize usernameSize = [username dra
}




@end
