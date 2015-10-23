//
//  TagListView.h
//  TagListDemo
//
//  Created by AD-iOS on 15/10/23.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickedIndexBlock)(NSInteger index);
typedef void(^TagListViewUpdateFrameBlock)(CGRect frame);

@protocol TagListViewDelegate;

@interface TagListView : UIView

- (instancetype)initWithFrame:(CGRect)frame andTags:(NSArray*)tagsArr;

/**
 *  可以实现代理，也可以不实现，有相同的功能的block方法代替。
 */
@property (nonatomic, weak) id<TagListViewDelegate>delegate;

/**
 *  block传递点中的位置
 *
 *  @param block 点中的位置的block
 */
- (void)clickedIndex:(ClickedIndexBlock)block;

/**
 *  在自动布局计算完成后，会自动调整TagListView的height。该方法可根据需要自行使用。
 *
 *  @param block frame更新的block
 */
- (void)didUpdatedTagListViewFrame:(TagListViewUpdateFrameBlock)block;

/**
 *  tag的数据源
 */
@property (nonatomic, copy) NSArray *tagsArr;

/**
 *  tag的有效区域。默认（0，0，0，0）
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/**
 *  同一行两个相临tag的间距。默认8
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 *  两行tag之间的间距。默认8
 */
@property (nonatomic, assign) CGFloat lineSpacing;

/**
 *  tag标签的高度,一般情况下不设置。
 */
@property (nonatomic, assign) CGFloat itemHeight;

/**
 *  tag标签的字体，默认系统字体13号
 */
@property (nonatomic, strong) UIFont *font;

/**
 *  是否自动计算tag的高度。默认YES,当设置为NO时，需要设置itemHeight属性
 */
@property (nonatomic, assign) BOOL autoItemHeightWithFontSize;

/**
 *  标签的背景颜色，默认白色
 */
@property (nonatomic, strong) UIColor *tagBackgroundColor;

/**
 *  标签文字的颜色，默认黑色
 */
@property (nonatomic, strong) UIColor *tagTextColor;

/**
 *  标签边框的颜色,默认lightGrayColor
 */
@property (nonatomic, strong) UIColor *tagBoarderColor;

@end

@protocol TagListViewDelegate <NSObject>

@optional
/**
 *  点中tag后的代理，有block方法
 *
 *  @param tagListView ====
 *  @param index       点中的位置
 */
- (void)tagListView:(TagListView*)tagListView didClickedAtIndex:(NSInteger)index;

/**
 *  在自动布局计算完成后，会自动调整TagListView的height。该代理方法可根据需要自行使用。
 *
 *  @param tagListView =====
 *  @param frame       更新后的frame
 */
- (void)tagListView:(TagListView *)tagListView didUpdateFrame:(CGRect)frame;

@end
