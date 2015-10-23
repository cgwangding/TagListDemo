//
//  ViewController.m
//  TagListDemo
//
//  Created by AD-iOS on 15/10/23.
//  Copyright © 2015年 Adinnet. All rights reserved.
//

#import "ViewController.h"
#import "TagListView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *arr = @[@"lfaj",@"do you konw ", @"你是一个", @"都比", @"上邪" ,@"fjowjfqpwojefw",@"afwef 太暴力"];
    TagListView *tagView = [[TagListView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 0) andTags:arr];
    tagView.tagBoarderColor = [UIColor greenColor];
//    tagView.autoItemHeightWithFontSize = NO;
    tagView.itemHeight = 30;
//    tagView.contentInsets = UIEdgeInsetsMake(30, 20, 0, 100);
    tagView.itemSpacing = 20;
    tagView.lineSpacing = 30;
    tagView.font = [UIFont systemFontOfSize:30];
    tagView.tagBackgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
    tagView.tagTextColor = [UIColor orangeColor];
    [self.view addSubview:tagView];
    [tagView clickedIndex:^(NSInteger index) {
        NSLog(@"%lu",index);
    }];
    //该方法可根据需要自行使用
    [tagView didUpdatedTagListViewFrame:^(CGRect frame) {
        NSLog(@"%@",NSStringFromCGRect(frame));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
