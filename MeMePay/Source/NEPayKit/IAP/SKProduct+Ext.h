//
//  SKProduct+Ext.h
//  NEIAPKit
//
//  Created by zhang yinglong on 2017/10/19.
//  Copyright © 2017年 zhang yinglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (NEIAPKit)

@property (nonatomic, readonly) NSString *localizedPrice;

@end