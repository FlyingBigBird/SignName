//
//  PaySignNameController.h
//  FotileCSS
//
//  Created by BaoBaoDaRen on 2018/8/1.
//  Copyright © 2018年 康振超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PaySignNameInterface) {
    
    WLDetail = 0, //上门服务
    Pay,          //支付
    Other         //其他
};

@interface PaySignNameController : UIViewController

/**
 * push 入口
 */
@property (nonatomic, assign) PaySignNameInterface interface;

/**
 * 工单Id
 */
@property (nonatomic, copy) NSString * orderId;

/**
 * 工单类型
 */
@property (nonatomic, copy) NSString * orderType;

@end
