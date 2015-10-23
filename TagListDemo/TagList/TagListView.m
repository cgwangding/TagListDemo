//
//  TagListView.m
//  TagListDemo
//
//  Created by AD-iOS on 15/10/23.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import "TagListView.h"

@interface TagListView ()

@property (assign, nonatomic) CGFloat validContentWidth;

@property (strong, nonatomic) NSMutableArray *itemArray;

@property (copy, nonatomic) ClickedIndexBlock clickedIndexBlock;

@property (copy, nonatomic) TagListViewUpdateFrameBlock updateFrameBlock;

@end

@implementation TagListView

- (instancetype)initWithFrame:(CGRect)frame andTags:(NSArray*)tagsArr
{
    if (self = [super initWithFrame:frame]) {
        [self configInitValueForProperty];
        self.tagsArr = tagsArr;
        [self checkObjectTypeNSString];
        [self makeItems];
        [self resetItemsFrame];
        
    }
    return self;
}

- (void)clickedIndex:(ClickedIndexBlock)block
{
    self.clickedIndexBlock = block;
}

- (void)didUpdatedTagListViewFrame:(TagListViewUpdateFrameBlock)block
{
    self.updateFrameBlock = block;
}

- (void)checkObjectTypeNSString
{
    for (id obj in self.tagsArr) {
        NSAssert([obj isKindOfClass:[NSString class]], @"tag标签中的数据只能是字符串");
    }
}

- (void)configInitValueForProperty
{
    _contentInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _itemSpacing = 8;
    _lineSpacing = 8;
    _font = [UIFont systemFontOfSize:13];
    _autoItemHeightWithFontSize = YES;
    _tagBackgroundColor = [UIColor whiteColor];
    _tagTextColor = [UIColor blackColor];
    _tagBoarderColor = [UIColor lightGrayColor];
    
    if (self.autoItemHeightWithFontSize) {
        UIFontDescriptor *fontDescriptor = [self.font fontDescriptor];
        _itemHeight = [[[fontDescriptor fontAttributes] objectForKey:UIFontDescriptorSizeAttribute] floatValue] + 4;
    }
    
    self.validContentWidth = CGRectGetWidth(self.frame) - self.contentInsets.right;
}

- (void)makeItems
{
    for (NSString *tagStr in self.tagsArr) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = self.font;
        button.backgroundColor = self.tagBackgroundColor;
        [button setTitleColor:self.tagTextColor forState:UIControlStateNormal];
        [button setTitle:tagStr forState:UIControlStateNormal];
        button.layer.borderColor = self.tagBoarderColor.CGColor;
        button.layer.borderWidth = 1;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemArray addObject:button];
        [self addSubview:button];
    }
}

- (void)resetItemsFrame
{
    CGFloat x = self.contentInsets.left;
    CGFloat y = self.contentInsets.top;
    for (UIButton *button in self.itemArray) {
        //计算文字所占的宽高
        CGSize size = [button.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        size.width += self.itemHeight;
        [button setFrame:CGRectMake(x, y, size.width, self.itemHeight)];
        button.layer.cornerRadius = self.itemHeight / 2;
        button.layer.masksToBounds = YES;
        
        //判断是否已经超出了有效区域
        if (CGRectGetMaxX(button.frame) > self.validContentWidth) {
            //如果超出换行到下一行
            //重新计算x,y
            x = self.contentInsets.left;
            y = CGRectGetMaxY(button.frame) + self.lineSpacing;
            button.frame = CGRectMake(x, y, size.width, self.itemHeight);
            
            }
            //计算下一个的x,y
            x += size.width + self.itemSpacing;
            y = button.frame.origin.y;
        
    }
    UIButton *lastObj = [self.itemArray lastObject];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(lastObj.frame) + self.contentInsets.bottom);
    if (self.updateFrameBlock) {
         self.updateFrameBlock(self.frame);
    }
    if ([self.delegate respondsToSelector:@selector(tagListView:didUpdateFrame:)]) {
        [self.delegate tagListView:self didUpdateFrame:self.frame];
    }
}

#pragma mark - frame helper


#pragma mark - button action

- (void)buttonClicked:(UIButton*)button
{
    if (self.clickedIndexBlock) {
        self.clickedIndexBlock([self.itemArray indexOfObject:button]);
    }
    if ([self.delegate respondsToSelector:@selector(tagListView:didClickedAtIndex:)]) {
        [self.delegate tagListView:self didClickedAtIndex:[self.itemArray indexOfObject:button]];
    }
}

#pragma mark - setter 

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    _contentInsets = contentInsets;
    self.validContentWidth = CGRectGetWidth(self.frame) - self.contentInsets.right;
    [self resetItemsFrame];
}

- (void)setItemSpacing:(CGFloat)itemSpacing
{
    _itemSpacing = itemSpacing;
    [self resetItemsFrame];
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;
    [self resetItemsFrame];
}

- (void)setItemHeight:(CGFloat)itemHeight
{
    
    if (self.autoItemHeightWithFontSize) {
        return;
    }else{
        _itemHeight = itemHeight;
        [self resetItemsFrame];
    }
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    for (UIButton *button in self.itemArray) {
        button.titleLabel.font = font;
    }
    if (self.autoItemHeightWithFontSize) {
        UIFontDescriptor *fontDescriptor = [self.font fontDescriptor];
        _itemHeight = [[[fontDescriptor fontAttributes] objectForKey:UIFontDescriptorSizeAttribute] floatValue] + 4;
    }
    [self resetItemsFrame];
}

- (void)setAutoItemHeightWithFontSize:(BOOL)autoItemHeightWithFontSize
{
    _autoItemHeightWithFontSize = autoItemHeightWithFontSize;
    if (autoItemHeightWithFontSize) {
        UIFontDescriptor *fontDescriptor = [self.font fontDescriptor];
        _itemHeight = [[[fontDescriptor fontAttributes] objectForKey:UIFontDescriptorSizeAttribute] floatValue] + 4;
        [self resetItemsFrame];
    }
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor
{
    _tagBackgroundColor = tagBackgroundColor;
    for ( UIButton *button in self.itemArray) {
        button.backgroundColor = tagBackgroundColor;
    }
}

- (void)setTagTextColor:(UIColor *)tagTextColor
{
    _tagTextColor = tagTextColor;
    for ( UIButton *button in self.itemArray) {
        [button setTitleColor:tagTextColor forState:UIControlStateNormal];
    }
}

- (void)setTagBoarderColor:(UIColor *)tagBoarderColor
{
    _tagBoarderColor = tagBoarderColor;
    for ( UIButton *button in self.itemArray) {
        button.layer.borderColor = tagBoarderColor.CGColor;
    }
}

#pragma mark - getter

- (NSMutableArray *)itemArray
{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

@end
