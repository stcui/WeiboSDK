//
//  WeiboCellView.h
//  SinaWeiboOAuthDemo
//
//  Created by stcui on 11-6-14.
//  Copyright 2011年 stcui. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeiboCell : UITableViewCell {
    id _object;
}

@property (nonatomic, readonly) UILabel *bottomTitleLabel;
@property (nonatomic, readonly) UILabel *bottomDetailLabel;

+ (CGFloat)cellHeightForObject:(id)object;
- (void)setObject:(id)object;
@end
