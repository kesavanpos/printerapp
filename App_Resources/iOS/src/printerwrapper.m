#import "printerwrapper.h"


@implementation printerwrapper

-(BOOL) openReader{
    
    LabelPrinterSDK* printer = [LabelPrinterSDK new];
    
    __SDK_RESULT_CODES_ result = [printer open];
    
    if(result == _SDK_RESULT_SUCCESS)
    {
        return true;
    }
    else
    {
        return false;
    }
}

-(BOOL) isPrinterConnected{
    LabelPrinterSDK* sdk = [self sharedInstance];
    
    // SDK Open
    __SDK_RESULT_CODES_ result = [sdk open];
    return true;
}

-(NSString *) getPairedDevices{
    NSString* printerName = @"No Paired Devices";
    
    LabelPrinterSDK* sdk = [self sharedInstance];
    [sdk CancelToLookupPrinter];
    
    printerName = @"SDK is Open Already";
    NSArray* arrPairedDevices = [sdk getPairedDevices];
    LabelPrinterObject *printerObj = [arrPairedDevices firstObject];
    
    if(printerObj != nil)
    {
        NSString* modelname = [printerObj getModelName];
        NSString* bluetooth = [printerObj getBluetoothDeviceName];
        
        [sdk connectWithSerialNumber:printerObj.getSerialNumber];
        
        printerName = [[NSString alloc] initWithFormat:@"%@ %@",modelname,bluetooth];
    }
    else{
        printerName = @"SDK is Open Already But Paired Devices is Empty";
    }
    
    return printerName;
}

- (LabelPrinterSDK *) sharedInstance {
    static LabelPrinterSDK* instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[LabelPrinterSDK alloc] init];
    });
    return instance;
}

-(NSString *) print:(NSString *) value {
    LabelPrinterSDK* sdk = [self sharedInstance];
    [sdk CancelToLookupPrinter];
    
    NSArray *listItems = [value componentsSeparatedByString:@","];
    
    NSInteger xPos = [[listItems objectAtIndex:0] intValue];
    NSInteger yPos = [[listItems objectAtIndex:1] intValue];
    NSInteger start = [[listItems objectAtIndex:2] intValue];
    NSInteger end = [[listItems objectAtIndex:3] intValue];
    NSInteger width = [[listItems objectAtIndex:4] intValue];
    
    NSArray* arrPairedDevices = [sdk getPairedDevices];
    LabelPrinterObject *printerObj = [arrPairedDevices firstObject];
    
    if(printerObj != nil)
    {
        [sdk connectWithSerialNumber:printerObj.getSerialNumber];
        
        BOOL dither = true;
        
        __SDK_RESULT_CODES_ result = [sdk printPDF:[NSBundle.mainBundle pathForResource:@"SamplePDF" ofType:@"pdf"]
                                             startPosX:0
                                             startPosY:0
                                             startPage:1
                                               endPage:1
                                                 width:width
                                                 level:50
                                          useDithering:dither];
       
        return [self modeToString:result];
    }
    
    return @"";
}

/*
_SDK_RESULT_SUCCESS                     = 0x0000,
_SDK_RESULT_FAIL                        = 0xF000,
_SDK_RESULT_FAIL_NOT_SUPPORT_FUNCTION  ,// = 0xF002,
_SDK_RESULT_FAIL_NO_OPEN               ,
_SDK_RESULT_FAIL_OPEN_ALREADY          ,
_SDK_RESULT_FAIL_NO_CONNECT            ,
_SDK_RESULT_FAIL_CONNECT_ALREADY       ,
_SDK_RESULT_FAIL_WRITE_ERROR           ,
_SDK_RESULT_FAIL_READ_ERROR            ,
_SDK_RESULT_FAIL_INVALID_PARAMETER
*/

- (NSString*)modeToString:(__SDK_RESULT_CODES_)mode{
    NSString *result = nil;
    switch(mode) {
        case _SDK_RESULT_SUCCESS :
            result = @"_SDK_RESULT_SUCCESS";
            break;
        case _SDK_RESULT_FAIL :
            result = @"_SDK_RESULT_FAIL";
            break;
        case _SDK_RESULT_FAIL_NOT_SUPPORT_FUNCTION:
            result = @"_SDK_RESULT_FAIL_NOT_SUPPORT_FUNCTION";
            break;
        case _SDK_RESULT_FAIL_NO_OPEN:
            result = @"_SDK_RESULT_FAIL_NO_OPEN";
            break;
            
        case _SDK_RESULT_FAIL_OPEN_ALREADY :
            result = @"_SDK_RESULT_FAIL_OPEN_ALREADY";
            break;
        case _SDK_RESULT_FAIL_NO_CONNECT:
            result = @"_SDK_RESULT_FAIL_NO_CONNECT";
            break;
        case _SDK_RESULT_FAIL_CONNECT_ALREADY:
            result = @"_SDK_RESULT_FAIL_CONNECT_ALREADY";
            break;
        case _SDK_RESULT_FAIL_WRITE_ERROR:
            result = @"_SDK_RESULT_FAIL_WRITE_ERROR";
            break;
            
        case _SDK_RESULT_FAIL_READ_ERROR:
            result = @"_SDK_RESULT_FAIL_READ_ERROR";
            break;
        case _SDK_RESULT_FAIL_INVALID_PARAMETER:
            result = @"_SDK_RESULT_FAIL_INVALID_PARAMETER";
            break;
            
            
        default:
            [NSException raise:NSGenericException format:@"Unexpected MODE."];
    }
    return result;
}

@end
