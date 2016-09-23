//
//  ThirdViewController.m
//  Test1
//
//  Created by liuhaiyang on 16/8/25.
//  Copyright © 2016年 上海中兴. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

struct CTResult
{
    int flag;
    int a;
};

id _CTServerConnectionCreate(CFAllocatorRef, void*, int*);


CFStringRef CTSIMSupportCopyMobileSubscriberCountryCode(CFAllocatorRef);
CFStringRef CTSIMSupportCopyMobileSubscriberNetworkCode(CFAllocatorRef);

#ifdef __LP64__

void _CTServerConnectionGetLocationAreaCode(id, int*);
void _CTServerConnectionGetCellID(id, int*);

//获取制式
void _CTServerConnectionGetActiveWirelessTechnology(id, CFStringRef *); //可行


void _CTServerConnectionCopyServingPLMN(id, CFStringRef *);

#else

void _CTServerConnectionGetLocationAreaCode(struct CTResult*, id, int*);
#define _CTServerConnectionGetLocationAreaCode(connection, LAC) { struct CTResult res; _CTServerConnectionGetLocationAreaCode(&res, connection, LAC); }

void _CTServerConnectionGetCellID(struct CTResult*, id, int*);
#define _CTServerConnectionGetCellID(connection, CID) { struct CTResult res; _CTServerConnectionGetCellID(&res, connection, CID); }

#endif





@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    int CID, LAC, MCC, MNC;
    
    id CTConnection = _CTServerConnectionCreate(NULL, NULL, NULL);
    _CTServerConnectionGetCellID(CTConnection, &CID);
    _CTServerConnectionGetLocationAreaCode(CTConnection, &LAC);
    MCC = [(__bridge NSString*)CTSIMSupportCopyMobileSubscriberCountryCode(NULL) intValue];
    MNC = [(__bridge NSString*)CTSIMSupportCopyMobileSubscriberNetworkCode(NULL) intValue];
    
    CFStringRef str = NULL;
    int a = 0;
    CFDictionaryRef dic;
    _CTServerConnectionCopyServingPLMN(CTConnection, &str);
    
    NSLog(@"a = %d  str = %@", a , str);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
