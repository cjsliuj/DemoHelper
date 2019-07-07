//
//  ViewController.m
//  TestApp
//
//  Created by 刘杰 on 2019/7/7.
//  Copyright © 2019 jerry. All rights reserved.
//

#import "ViewController.h"
@import DemoHelper;
@interface ViewController ()<DHMenuViewDelegate>
@property (weak, nonatomic) IBOutlet DHMenuView * menuView1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DHMenuRow * row1 = [[DHMenuRow alloc]initWithTitle:@"row1" action:^{
        NSLog(@"on click row1");
    }];
    DHMenuSection * sec1 = [[DHMenuSection alloc]initWithTitle:@"test" rows:@[row1]];
    
    DHMenuRow * row2 = [[DHMenuRow alloc]initWithTitle:@"row2" action:^{
        NSLog(@"on click row2");
    }];
    DHMenuSection * sec2 = [[DHMenuSection alloc]initWithTitle:@"test" rows:@[row2]];
    
    
    _menuView1.dataSource = @[sec1, sec2];
    _menuView1.delegate = self;
}
- (void)dhMenuViewOnClickedRowWithMenuView:(DHMenuView *)menuView row:(DHMenuRow *)row{
    NSLog(@"xxx%@", row);
}

@end
