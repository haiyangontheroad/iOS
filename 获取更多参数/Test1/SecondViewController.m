//
//  SecondViewController.m
//  Test1
//
//  Created by liuhaiyang on 16/8/25.
//  Copyright © 2016年 上海中兴. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end


extern CFStringRef const kCTRegistrationCellChangedNotification;
//extern CFStringRef const kCTRegistrationGsmLac;
extern CFStringRef const kCTRegistrationLac;
//extern CFStringRef const kCTRegistrationGsmCellId;
extern CFStringRef const kCTRegistrationCellId;

CFStringRef CTSIMSupportCopyMobileSubscriberCountryCode(CFAllocatorRef);
CFStringRef CTSIMSupportCopyMobileSubscriberNetworkCode(CFAllocatorRef);

id CTTelephonyCenterGetDefault();
void CTTelephonyCenterAddObserver(id, void *, CFNotificationCallback, CFStringRef, void *, CFNotificationSuspensionBehavior);



@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    CTTelephonyCenterAddObserver(CTTelephonyCenterGetDefault(), NULL, callback, NULL, NULL, CFNotificationSuspensionBehaviorHold);
    

    
    
}

void callback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    NSString* notification = (__bridge NSString*)name;
    NSDictionary *cellInfo = (__bridge NSDictionary*)userInfo;
    
    if ([notification isEqualToString:(NSString*)kCTRegistrationCellChangedNotification])
    {
        int LAC, CID, MCC, MNC;
        
//        if (cellInfo[(NSString*)kCTRegistrationGsmLac])
//        {
//            LAC = [cellInfo[(NSString*)kCTRegistrationGsmLac] intValue];
//        }
         if (cellInfo[(NSString*)kCTRegistrationLac])
        {
            LAC = [cellInfo[(NSString*)kCTRegistrationLac] intValue];
        }
        
//        if (cellInfo[(NSString*)kCTRegistrationGsmCellId])
//        {
//            CID = [cellInfo[(NSString*)kCTRegistrationGsmCellId] intValue];
//        }
         if (cellInfo[(NSString*)kCTRegistrationCellId])
        {
            CID = [cellInfo[(NSString*)kCTRegistrationCellId] intValue];
        }
        
        MCC = [(__bridge NSString*)CTSIMSupportCopyMobileSubscriberCountryCode(NULL) intValue];
        MNC = [(__bridge NSString*)CTSIMSupportCopyMobileSubscriberNetworkCode(NULL) intValue];
    }
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
