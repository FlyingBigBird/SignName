//
//  PaySignNameController.m
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/8/1.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import "PaySignNameController.h"
#import "LYDrawBoard.h"
#import "PhotoViewController.h"
#import "UIView+Extension.h"

@interface PaySignNameController ()<BasicNavigationBarViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) LYDrawBoard *pointView;

@end

@implementation PaySignNameController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F8F7F4"];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //禁用屏幕侧滑返回手势，防止支付中侧滑返回，倒计时未停止
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    //开启屏幕侧滑返回手势
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setPaySignNameControllerSubs];
}

- (void)setPaySignNameControllerSubs
{
    [self setSignView];
    
    BasicNavigationBarView * customNavBar = [[BasicNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavBar_H + StatusBar_H)];
    customNavBar.delegate = self;
    [customNavBar setNavigationBarWith:@"签名" andBGColor:[UIColor clearColor] andTitleColor:[UIColor blackColor] andImage:@"nav_left_back" andHidLine:NO];
    [customNavBar setCustomNavBarRightButtonTitle:@"完成" andTitleColor:[UIColor blackColor]];
    [self.view addSubview:customNavBar];
}

- (void)setSignView
{
    self.pointView = [[LYDrawBoard alloc] initWithFrame:CGRectMake(15, NavBar_H + StatusBar_H + 10, SCREEN_WIDTH - 30, SCREEN_HEIGHT - NavBar_H - StatusBar_H - 50 - 10 - (TabBar_H-44))];
    self.pointView.color = [UIColor colorWithHexString:@"#FF7F00"];
    self.pointView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pointView];
    self.pointView.layer.masksToBounds = YES;
    self.pointView.layer.cornerRadius = 10;
    
    UIButton * saveSignBtn = [[UIButton alloc] init];
    [self.view addSubview:saveSignBtn];
    [saveSignBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveSignBtn resetWithButton:saveSignBtn withCornerRadius:2 withTitleColor:GBlackColor withBackColor:[UIColor colorWithHexString:@""] withTitleFont:14];
    [saveSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.pointView.mas_bottom).offset(5);
        make.left.mas_equalTo(self.view.mas_left).offset(SCREEN_WIDTH / 4 - 80 / 2);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    [saveSignBtn addTarget:self action:@selector(saveSignPictureAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * reSignBtn = [[UIButton alloc] init];
    [self.view addSubview:reSignBtn];
    [reSignBtn setTitle:@"重签" forState:UIControlStateNormal];
    [reSignBtn resetWithButton:reSignBtn withCornerRadius:2 withTitleColor:GBlackColor withBackColor:GBoarderColor withTitleFont:14];
    [reSignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.pointView.mas_bottom).offset(5);
        make.right.mas_equalTo(self.view.mas_right).offset(-(SCREEN_WIDTH / 4 - 80 / 2));
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    [reSignBtn addTarget:self action:@selector(reSignPictureAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)saveSignPictureAction
{
    if (_pointView.points.count)
    {
        UIImage * image = [UIView captureWithView:_pointView];
        [self saveSickDocImageToPhotos:image];
    } else
    {
        [self showCustomEnsureAlert:@"您尚未签名"];
    }
}

#pragma mark - 将图片保存到相册
- (void)saveSickDocImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *msg = nil ;
    if (error != NULL){
        msg = NSLocalizedString(@"保存图片失败", nil);
    } else {
        msg = NSLocalizedString(@"保存图片成功", nil);
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil) message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
    [alert show];
}

- (void)reSignPictureAction
{
    [self.pointView clear];
}

#pragma mark - BasicNavigationBarViewDelegate
- (void)customNavgationBarDidClicked
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"取消签名" message:@"签名未完成，是否返回?" preferredStyle:UIAlertControllerStyleAlert];
    
    WeakSelf(self);
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (weakself.interface == Pay) {
            
            [weakself backVC];
        } else {
            
            [weakself.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [weakself dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)customNavgationRightBarButtonClicked
{
    if (_pointView.points.count)
    {
        UIImage *image = [UIView captureWithView:_pointView];
        
        if (self.interface == WLDetail || self.interface == Pay) {
            
            [self upLoadSignImage:image];
        }
    } else
    {
        [self showCustomEnsureAlert:@"您尚未签名"];
    }
}

#pragma mark - 网络请求 数据处理

//上传签字图片
- (void)upLoadSignImage:(UIImage *)image
{
    
}


- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    [self backVC];
}

- (void)backVC {
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showCustomEnsureAlert:(NSString *)message
{
    UIAlertView * ensureAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [ensureAlert show];
}

@end
