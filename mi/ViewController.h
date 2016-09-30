//
//  ViewController.h
//  mi
//
//  Created by David L-R on 24/09/2016.
//  Copyright © 2016 David L-R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface ViewController : UIViewController <CBCentralManagerDelegate>
@property (nonatomic, strong) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
- (IBAction)shake:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)pair:(id)sender;
- (IBAction)readUserData:(id)sender;


@end

