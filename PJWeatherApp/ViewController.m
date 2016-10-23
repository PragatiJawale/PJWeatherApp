//
//  ViewController.m
//  PJWeatherApp
//
//  Created by Mac on 17/10/16.
//  Copyright © 2016 Pragati Jawale. All rights reserved.
//

#import "ViewController.h"
//#import "ForecastTableViewCell.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   // NSArray *days = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
    forecast = [[NSMutableArray alloc]init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startLocating {
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"lattitude = %f",currentLocation.coordinate.latitude);
    
    NSLog(@"longitude = %f",currentLocation.coordinate.longitude);
    
    kLatitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude ];
    kLongitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    [self getweekDaysWeatherDataWithLatitude:kLatitude longitude:kLongitude APIKey:kWeatherApiKey];
    
    [self getCurrentWeatherDataWithLatitude:kLatitude.doubleValue longitude:kLongitude.doubleValue APIKey:kWeatherApiKey];
    
    
    if (currentLocation !=nil) {
        [locationManager stopUpdatingLocation];
    }
    
    
    //[self getweekDaysWeatherDataWithLatitude:kLatitude longitude:kLongitude APIKey:kWeatherAPIKey];
    
}
-(void)getCurrentWeatherDataWithLatitude:(double)latitude
                               longitude:(double)longitude
                                  APIKey:(NSString *)key{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@",latitude,longitude,key];
    NSLog(@"%@",urlString);
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            
        }
        else{
            if(response){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode == 200)
                {
                    if (data) {
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        if(error){
                            
                        }
                        else{
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                }
            }
        }
    }];
    [task resume];
}
-(void)updateUI:(NSDictionary *)resultDictionary {
    
    // NSLog(@"%@",resultDictionary);
    
    
    
    NSString *temperature = [NSString stringWithFormat:@"%@",[resultDictionary valueForKeyPath:@"main.temp"]];
    
    
    
    int temp = temperature.intValue;
    
    temperature = [NSString stringWithFormat:@"%d °C",temp];
    
    
    
    NSArray *weather = [resultDictionary valueForKey:@"weather"];
    
    
    NSDictionary *weatherDictionary = weather.firstObject;
    
    
    
    
    NSString *condition = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
    //  NSLog(@"%@",condition);
    
    
    NSString *city = [NSString stringWithFormat:@"%@",[resultDictionary valueForKey:@"name"]];
    
    
    self.labelCity.text = city;
    self.labelCondition.text = condition.capitalizedString;
    self.labelTemperature.text = temperature;
    
    
}




-(void)getweekDaysWeatherDataWithLatitude:(NSString *)latitude
                                longitude:(NSString *)longitude
                                   APIKey:(NSString *)key{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=7&mode=json&appid=%@",latitude,longitude,key];
    //  NSLog(@"%@",urlString);
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            
        }
        else{
            if(response){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode == 200)
                {
                    if (data) {
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        if(error){
                            
                        }
                        else{
                            [self performSelectorOnMainThread:@selector(updateUIFor7Days:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                }
            }
        }
    }];
    [task resume];
}
-(void)updateUIFor7Days:(NSDictionary *)resultDictionary{
    NSLog(@"%@",resultDictionary);
    
    list = [resultDictionary valueForKey:@"list"];
    // NSLog(@"%@",list);
    if (forecast.count > 0) {
        [forecast removeAllObjects];
        
    }
    for (NSDictionary *weatherDetail in list) {
        
        
        NSString *max = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.max"]];
        max = [NSString stringWithFormat:@"%d°C",max.intValue];
        NSString *min = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.min"]];
        min = [NSString stringWithFormat:@"%d°C",min.intValue];
        
        
        NSDictionary *myDictionary = @{
                                       @"date" : [NSString stringWithFormat:@"%@",[weatherDetail valueForKey:@"dt"]],
                                       @"maximum_temp" : max,
                                       @"minimum_temp" : min
                                       
                                       };
        // NSLog(@"%@",myDictionary);
        
        [forecast addObject:myDictionary];
        NSLog(@"forcast %@",forecast);
        
        
    }
    
    if (forecast.count > 0) {
        [self.myTableView reloadData];
    }
}





- (IBAction)actionGetCurrentWeather:(id)sender {
    [self startLocating];

   }
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return devices.count;
    
    return forecast.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Forecast_cell"];
    //   cell.labelDays.text =[arrayweekdays objectAtIndex:indexPath.row];
    NSDictionary *temp = [forecast objectAtIndex:indexPath.row];
    
    NSLog(@"%@",temp);
    
    
    NSString *dt = [temp valueForKey:@"date"];
    
    NSTimeInterval time = dt.doubleValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSString *day = [dateFormatter stringFromDate:date];
    NSLog(@"%@",day);
    
    //    cell.labelDays.text = [arrayweekdays objectAtIndex:indexPath.row];
    
    cell.labelDay.text = day;
    //      cell.labelMaxTemperature.text =
    cell.labelMaximumTemperature.text =[temp valueForKey:@"maximum_temp"];
    cell.labelMinimumTemperature.text = [temp valueForKey:@"minimum_temp"];
    cell.backgroundColor =[UIColor cyanColor];
   // cell.tintColor =[UIColor purpleColor];
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return tableView.frame.size.height/7;
    
}





@end
