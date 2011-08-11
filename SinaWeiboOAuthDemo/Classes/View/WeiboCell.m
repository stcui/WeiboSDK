//
//  WeiboCellView.m
//  SinaWeiboOAuthDemo
//
//  Created by stcui on 11-6-14.
//  Copyright 2011年 stcui. All rights reserved.
//

#import "WeiboCell.h"
#import "Status.h"
#import "StatusView.h"

@implementation WeiboCell
@synthesize bottomTitleLabel = _bottomTitleLabel;
@synthesize bottomDetailLabel = _bottomDetailLabel;

+ (CGFloat)detailHeightOfText:(NSString *)text {
    if (nil == text) return 0.0;
    
    return [text sizeWithFont:[UIFont systemFontOfSize:16]
            constrainedToSize:CGSizeMake(214, CGFLOAT_MAX) 
                lineBreakMode:UILineBreakModeCharacterWrap].height;                    
}

+ (CGFloat)cellHeightForObject:(Status *)object {
    CGFloat height = [self detailHeightOfText:object.text] + 33 + 16.0;
    if (object.retweetedStatus) {
        height += 38;
    }
    
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        self.contentView.backgroundColor = self.backgroundColor;
//        self.textLabel.font = [UIFont systemFontOfSize:15];
//        self.textLabel.backgroundColor = [UIColor clearColor];
//        
//        self.detailTextLabel.backgroundColor = [UIColor clearColor];
//        self.detailTextLabel.textColor = [UIColor blackColor];
//        self.detailTextLabel.font = [UIFont systemFontOfSize:16];
//        self.detailTextLabel.numberOfLines = 0;
//        self.detailTextLabel.lineBreakMode = UILineBreakModeCharacterWrap;
//        
//        // Init Controls
//        _bottomTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _bottomTitleLabel.font = [UIFont boldSystemFontOfSize:14];
//        _bottomTitleLabel.backgroundColor = [UIColor clearColor];
//        
//        _bottomDetailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _bottomDetailLabel.font = [UIFont systemFontOfSize:14];
//        _bottomDetailLabel.backgroundColor = [UIColor clearColor];
//        
//        [self.contentView addSubview:_bottomTitleLabel];
//        [self.contentView addSubview:_bottomDetailLabel];
//        self.contentView.backgroundColor = [UIColor greenColor];
        StatusView *view = [[StatusView alloc] initWithFrame:self.contentView.frame];
        view.frame = CGRectMake(0, 3.0, self.contentView.frame.size.width, self.contentView.frame.size.height - 6.0);
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:view];
        [view release];
    }
    
    return self;
}

- (void)dealloc {
    [_object release];
    [super dealloc];
}

//- (void)drawRect:(CGRect)rect {
//    [self.backgroundColor set];
//    UIRectFill(rect);
//    UIImage *bgImage = [[UIImage imageNamed:@"WeiboBg"] stretchableImageWithLeftCapWidth:0 topCapHeight:30.0];
//    CGRect bgFrame = CGRectMake(70, 3.0, 240, rect.size.height - 6.0);
//    [bgImage drawInRect:bgFrame];
//    if ([(Status*)_object retweetedStatus]) {
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(ctx);
//        CGRect detailFrame = self.detailTextLabel.frame;
//        CGFloat y = CGRectGetMaxY(detailFrame) + 10;
//        //CGContextSetRGBStrokeColor(ctx, 0.8, 0.82, 0.878, 1.0);
//        CGContextSetRGBStrokeColor(ctx, 0.18, 0.82, 0.878, 1.0);
//        
//        CGContextStrokeLineSegments(ctx, (const CGPoint[]){{CGRectGetMinX(detailFrame) + 17.0, y}, {CGRectGetMaxX(detailFrame) - 7.0, y}}, 4);
//        CGContextRestoreGState(ctx);
//    }
//}

//- (void)layoutSubviews {
//    self.textLabel.frame = CGRectMake(80, 13, 145, 16);
//    self.imageView.frame = CGRectMake(8, 5, 55, 57);
//    self.detailTextLabel.frame = CGRectMake(80, 33, 214, [WeiboCell detailHeightOfText:self.detailTextLabel.text]);
//    if (_bottomTitleLabel.text) {
//        _bottomTitleLabel.hidden = NO;
//        _bottomDetailLabel.hidden = NO;
//        
//        CGRect detailFrame = self.detailTextLabel.frame;
//        _bottomTitleLabel.frame = CGRectMake(detailFrame.origin.x + 3, detailFrame.origin.y + detailFrame.size.height + 20, 0, 0);
//        [_bottomTitleLabel sizeToFit];
//        CGRect titleFrame = _bottomTitleLabel.frame;
//        _bottomDetailLabel.frame = CGRectMake(titleFrame.origin.x + titleFrame.size.width,
//                                              titleFrame.origin.y,
//                                              self.contentView.bounds.size.width - titleFrame.size.width - titleFrame.origin.x,
//                                              titleFrame.size.height);
//    } else {
//        _bottomTitleLabel.hidden = YES;
//        _bottomDetailLabel.hidden = YES;
//        _bottomTitleLabel.frame = CGRectZero;
//        _bottomDetailLabel.frame = CGRectZero;
//    }
//    [self sizeToFit];
//}

- (void)setObject:(Status*)status {
//    if (_object == status) return;
//    [_object release];
//    _object = [status retain];
//    self.textLabel.text = status.user.screenName;
//	self.detailTextLabel.text = status.text;
//    if (status.retweetedStatus) {
//        self.bottomTitleLabel.text = [NSString stringWithFormat:@"%@:", status.retweetedStatus.user.name];
//        self.bottomDetailLabel.text = status.retweetedStatus.text;        
//    } else {
//        self.bottomTitleLabel.text = nil;
//        self.bottomDetailLabel.text = nil;
//    }
//    [self setNeedsLayout];
    [[[self.contentView subviews] lastObject] setStatus:status];
}

@end
