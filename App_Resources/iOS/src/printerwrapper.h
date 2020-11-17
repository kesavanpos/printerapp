
#import "LabelPrinterSDK.h"

@interface printerwrapper : NSObject
-(BOOL) openReader;
-(BOOL) isPrinterConnected;
-(NSString *) getPairedDevices;
-(LabelPrinterSDK *) sharedInstance;
-(NSString *) print:(NSString *) value;
@end

