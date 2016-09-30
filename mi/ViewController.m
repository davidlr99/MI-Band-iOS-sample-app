//
//  ViewController.m
//  mi
//
//  Created by David Layer-Reiss on 24/09/2016.
//  Copyright © 2016 David Layer-Reiss. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSMutableDictionary *char_dic;
//    public static final byte[] PAIR = {2};
//    public static final byte[] VIBRATION_WITH_LED = {1};
//    public static final byte[] VIBRATION_10_TIMES_WITH_LED = {2};
//    public static final byte[] VIBRATION_WITHOUT_LED = {4};
//    public static final byte[] STOP_VIBRATION = {0};
//    public static final byte[] ENABLE_REALTIME_STEPS_NOTIFY = {3, 1};
//    public static final byte[] DISABLE_REALTIME_STEPS_NOTIFY = {3, 0};
//    public static final byte[] ENABLE_SENSOR_DATA_NOTIFY = {18, 1};
//    public static final byte[] DISABLE_SENSOR_DATA_NOTIFY = {18, 0};
//    public static final byte[] SET_COLOR_RED = {14, 6, 1, 2, 1};
//    public static final byte[] SET_COLOR_BLUE = {14, 0, 6, 6, 1};
//    public static final byte[] SET_COLOR_ORANGE = {14, 6, 2, 0, 1};
//    public static final byte[] SET_COLOR_GREEN = {14, 4, 5, 0, 1};
//    public static final byte[] START_HEART_RATE_SCAN = {21, 2, 1};
//    
//    public static final byte[] REBOOT = {12};
//    public static final byte[] REMOTE_DISCONNECT = {1};
//    public static final byte[] FACTORY_RESET = {9};
//    public static final byte[] SELF_TEST = {2};

}

@end

@implementation ViewController



- (void)viewDidLoad {
    NSLog(@"STarted");
    [super viewDidLoad];
    char_dic = [[NSMutableDictionary alloc]init];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
           
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware is resetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    CBPeripheral* currentPer = peripheral;
    //NSLog(@"Found: %@",currentPer.name);
    if([currentPer.name  isEqual: @"MI"] || [currentPer.name  isEqual: @"MI1S"])
    {
       [self.centralManager connectPeripheral:currentPer options:nil];
        _discoveredPeripheral = currentPer;
    }
    
    
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    
    NSLog(@"Connection successfull to peripheral: %@",peripheral);
    _discoveredPeripheral = peripheral;
    NSUUID* serverId = [peripheral identifier];
    NSLog(@"Mac: %@",serverId);
     peripheral.delegate = self;
    [peripheral discoverServices:nil];
    
    
    //Do somenthing after successfull connection.
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    
    for (CBService *service in peripheral.services) {
        //NSLog(@"looo");

        [peripheral discoverCharacteristics:nil forService:service];
    }
    // Discover other characteristics
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
   
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        [char_dic setObject:characteristic forKey:characteristic.UUID.UUIDString];
      [_discoveredPeripheral readValueForCharacteristic:characteristic];
    }
    [self makealert:@"Connected to MI band."];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    
    NSData *data = [characteristic value];      // 1
    const uint8_t *reportData = [data bytes];
    NSString *t = [NSString stringWithFormat:@"%@",characteristic.UUID];
    if ([t  isEqual: @"FF02"]) {
        NSLog(@"%s %@",reportData,characteristic.UUID);
//        NSData *bytes = [@"NJJNJNJNJNNJJNNJGZFCTDCFJHVGKJBKNHGJFDHXRTCJZVKHJBHFCGVGBCHGXDFCHV" dataUsingEncoding:NSUTF8StringEncoding];
//        [_discoveredPeripheral writeValue:bytes forCharacteristic:char_dic[@"FF02"] type:CBCharacteristicWriteWithResponse];
//        [_discoveredPeripheral readValueForCharacteristic:char_dic[@"FF02"]];

    }
    


}
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Connection failed to peripheral: %@",peripheral);
    
    //Do something when a connection to a peripheral failes.
}




- (IBAction)shake:(id)sender {
    //while (true) {
        Byte zd[1] = {4};
        NSData *theData = [NSData dataWithBytes:zd length:1];
        NSLog(@"dic %@",char_dic);
        [_discoveredPeripheral writeValue:theData forCharacteristic:char_dic[@"2A06"] type:CBCharacteristicWriteWithoutResponse];
        [NSThread sleepForTimeInterval:0.1];
    //}
    
    
}

-(void)makealert:(NSString*) tmessage{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Message"
                                 message:tmessage
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Okay"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)reset:(id)sender {
    Byte zd[1] = {1};
    NSData *data = [NSData dataWithBytes:zd length:1];
    [_discoveredPeripheral writeValue:data forCharacteristic:char_dic[@"FF0D"] type:CBCharacteristicWriteWithResponse];
}

- (IBAction)pair:(id)sender {
    Byte zd[1] = {2};
    NSData *data = [NSData dataWithBytes:zd length:1];
    [_discoveredPeripheral writeValue:data forCharacteristic:char_dic[@"FF0F"] type:CBCharacteristicWriteWithResponse];
}

- (IBAction)readUserData:(id)sender {
    //2A39
    Byte heartscan[] = {21, 2, 1};
    //Byte heartscan[] = {14, 6, 1, 2, 1};
    
    NSData *data = [NSData dataWithBytes:heartscan length:3];
    [_discoveredPeripheral writeValue:data forCharacteristic:char_dic[@"2A39"] type:CBCharacteristicWriteWithResponse];

    

    [_discoveredPeripheral readValueForCharacteristic:char_dic[@"FF04"]];

}
@end
