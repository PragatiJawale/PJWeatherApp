//
//  ForecastTableViewCell.h
//  PJWeatherApp
//
//  Created by Mac on 23/10/16.
//  Copyright © 2016 Pragati Jawale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface ForecastTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelDay;
@property (strong, nonatomic) IBOutlet UILabel *labelMaximumTemperature;
@property (strong, nonatomic) IBOutlet UILabel *labelMinimumTemperature;

@end
