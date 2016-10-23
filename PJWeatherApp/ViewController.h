//
//  ViewController.h
//  PJWeatherApp
//
//  Created by Mac on 17/10/16.
//  Copyright © 2016 Pragati Jawale. All rights reserved.
//
#define kWeatherApiKey @"c78c3cc1a08746a5d8edcc3e9abaf206"
#import <UIKit/UIKit.h>
#import "ForecastTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *list;
    CLLocationManager *myLocationManger;
    NSString *kLatitude;
    NSString *kLongitude;
    CLLocationManager *locationManager;
    NSMutableArray *forecast;
    NSString *maxTemperature;
    //NSMutableArray *myArray;
    NSDictionary *maxTemp;
    
}
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) IBOutlet UILabel *labelCity;
@property (strong, nonatomic) IBOutlet UILabel *labelTemperature;
@property (strong, nonatomic) IBOutlet UILabel *labelCondition;
- (IBAction)actionGetCurrentWeather:(id)sender;

@end

