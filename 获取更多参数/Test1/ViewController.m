//
//  ViewController.m
//  Test1
//
//  Created by liuhaiyang on 16/8/25.
//  Copyright © 2016年 上海中兴. All rights reserved.
//

#import "ViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

ViewController *vc;

@implementation ViewController


struct CTResult
{
    int flag;
    int a;
};

extern CFStringRef const kCTCellMonitorCellType;
extern CFStringRef const kCTCellMonitorCellTypeServing;
extern CFStringRef const kCTCellMonitorCellTypeNeighbor;
extern CFStringRef const kCTCellMonitorCellId;
extern CFStringRef const kCTCellMonitorLAC;
extern CFStringRef const kCTCellMonitorMCC;
extern CFStringRef const kCTCellMonitorMNC;
extern CFStringRef const kCTCellMonitorUpdateNotification;

extern CFStringRef const kCTCellMonitorPCI;

id _CTServerConnectionCreate(CFAllocatorRef, void*, int*);
void _CTServerConnectionAddToRunLoop(id, CFRunLoopRef, CFStringRef);

#ifdef __LP64__

void _CTServerConnectionRegisterForNotification(id, CFStringRef);
void _CTServerConnectionCellMonitorStart(id);
void _CTServerConnectionCellMonitorStop(id);
void _CTServerConnectionCellMonitorCopyCellInfo(id, void*, CFArrayRef*);

void _CTServerConnectionCleanBasebandLogs(id);


#else

void _CTServerConnectionRegisterForNotification(struct CTResult*, id, CFStringRef);
#define _CTServerConnectionRegisterForNotification(connection, notification) { struct CTResult res; _CTServerConnectionRegisterForNotification(&res, connection, notification); }

void _CTServerConnectionCellMonitorStart(struct CTResult*, id);
#define _CTServerConnectionCellMonitorStart(connection) { struct CTResult res; _CTServerConnectionCellMonitorStart(&res, connection); }

void _CTServerConnectionCellMonitorStop(struct CTResult*, id);
#define _CTServerConnectionCellMonitorStop(connection) { struct CTResult res; _CTServerConnectionCellMonitorStop(&res, connection); }

void _CTServerConnectionCellMonitorCopyCellInfo(struct CTResult*, id, void*, CFArrayRef*);
#define _CTServerConnectionCellMonitorCopyCellInfo(connection, tmp, cells) { struct CTResult res; _CTServerConnectionCellMonitorCopyCellInfo(&res, connection, tmp, cells); }

#endif



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    

    vc = self;
//    
//    id CTConnection = _CTServerConnectionCreate(NULL, CellMonitorCallback, NULL);
//    _CTServerConnectionAddToRunLoop(CTConnection, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
//    _CTServerConnectionRegisterForNotification(CTConnection, kCTCellMonitorUpdateNotification);
//    
    
    
    
//    int tmp = 0;
//    CFArrayRef cells = NULL;
//    _CTServerConnectionCellMonitorCopyCellInfo(CTConnection, (void*)&tmp, &cells);
//    if (cells == NULL)
//    {
//        return;
//    }
//
    
//    _CTServerConnectionCellMonitorStart(CTConnection);
    
    
    
}


- (IBAction)publicAction:(id)sender {
    
    
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *acTech = netInfo.currentRadioAccessTechnology;
    
    CTCarrier *carrier = netInfo.subscriberCellularProvider;
    
    NSLog(@"网络制式：%@",acTech);
    NSLog(@"运营商：%@", carrier);
    
    
    // 间接获取信号强度
    {
        
        // 获取当前应用程序
        UIApplication *app = [UIApplication sharedApplication];
        
        // 获取状态栏的子视图
        NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
        NSString *dataNetworkItemView = nil;
        
        // 遍历子视图
        for (id subview in subviews) {
            
            // 找到显示信号强度的视图
            if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarSignalStrengthItemView") class]]) {
                dataNetworkItemView = subview;
                break;
            }
        }
        
        // 通过KVC获取信号强度
        int signalStrength = [[dataNetworkItemView valueForKey:@"signalStrengthRaw"] intValue];
        
        NSLog(@"信号强度 %d", signalStrength);
    }

    
    
    
    
}



- (IBAction)beginMonitorAction:(UIButton *)sender {
    
    id CTConnection = _CTServerConnectionCreate(NULL, CellMonitorCallback, NULL);
    
    int tmp = 0;
    CFArrayRef cells = NULL;
    _CTServerConnectionCellMonitorCopyCellInfo(CTConnection, (void*)&tmp, &cells);
    if (cells == NULL)
    {
        return;
    }
    
     
    
//    _CTServerConnectionCellMonitorStart(CTConnection);

    
    NSArray *cellArr = (__bridge NSArray*)cells;
    NSLog(@"%ld", cellArr.count);
    NSLog(@"%@", cellArr);
    
    vc.textView.text = cellArr.description;
    
    
    _CTServerConnectionCleanBasebandLogs(CTConnection);
    
}



int CellMonitorCallback(id connection, CFStringRef string, CFDictionaryRef dictionary, void *data)
{
    int tmp = 0;
    CFArrayRef cells = NULL;
    _CTServerConnectionCellMonitorCopyCellInfo(connection, (void*)&tmp, &cells);
    if (cells == NULL)
    {
        return 0;
    }
    
    
    NSArray *cellArr = (__bridge NSArray*)cells;
    NSLog(@"%ld", cellArr.count);
    NSLog(@"%@", [NSDate date]);
    
    
    for (NSDictionary* cell in cellArr)
    {
        
//         NSLog(@"%@", cell);
        
        int LAC, CID, MCC, MNC;
        
        NSLog(@"%@", cell[(NSString *)kCTCellMonitorPCI]);
        
//        if ([cell[(NSString*)kCTCellMonitorCellType] isEqualToString:(NSString*)kCTCellMonitorCellTypeServing])
//        {
//            
//            vc.textView.text = cell.description;
//            
//            LAC = [cell[(NSString*)kCTCellMonitorLAC] intValue];
//            CID = [cell[(NSString*)kCTCellMonitorCellId] intValue];
//            MCC = [cell[(NSString*)kCTCellMonitorMCC] intValue];
//            MNC = [cell[(NSString*)kCTCellMonitorMNC] intValue];
//        }
//        else if ([cell[(NSString*)kCTCellMonitorCellType] isEqualToString:(NSString*)kCTCellMonitorCellTypeNeighbor])
//        {
//        }
    }
    
    CFRelease(cells);
    return 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
