//
//  ViewController.m
//  SignNameDemo
//
//  Created by BaoBaoDaRen on 2019/9/2.
//  Copyright © 2019 Boris. All rights reserved.
//

#import "ViewController.h"
#import "PaySignNameController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"签字";
    
    [self showUI];
}
- (void)showUI
{
    CGFloat btnWH = 100;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(btnWH, btnWH));
    }];
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btnWH / 2;
    btn.backgroundColor = [UIColor redColor];
    
    [btn setTitle:@"去签名" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [btn addTarget:self action:@selector(nameSignBegin) forControlEvents:UIControlEventTouchUpInside];

}
- (void)nameSignBegin
{
    PaySignNameController * signVC = [[PaySignNameController alloc] init];
    signVC.interface = Pay;
    [self.navigationController pushViewController:signVC animated:YES];

}


@end
