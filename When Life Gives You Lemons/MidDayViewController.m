//
//  MidDayViewController.m
//  When Life Gives You Lemons
//
//  Created by jarthurcs on 10/21/14.
//  Copyright (c) 2014 Jonathan Finnell, Amit Maor, Joshua Petrack, Megan Shao, Rachel Wilson. All rights reserved.
//

#import "MidDayViewController.h"
#import "PostDayViewController.h"
#import "MidDayView.h"
#import "Model.h"

@interface MidDayViewController () {
    DataStore *_dataStore;
    MidDayView *_midDayView;
    Model *_model;
    Weather _currentWeather;
}
@end

@implementation MidDayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create the MidDay View
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    _midDayView = [[MidDayView alloc] initWithFrame:frame andDataStore:_dataStore];
    [self.view addSubview:_midDayView];
    
    // Get the current day's weather before running the Model
    _currentWeather = [_dataStore getWeather];
    
    // Run Model after creating MidDay View, so that it uses the old weather value
    _model = [[Model alloc] init];
    _dataStore = [self runModelWith:_dataStore];
    
    [self.view bringSubviewToFront:_goToPostDayButton];
    
}

- (void)setDataStore:(DataStore *) dataStore
{
    _dataStore = dataStore;
}

- (DataStore *)runModelWith:(DataStore *)dataStore
{
    // Run the model for the day and return the modified dataStore
    return [_model simulateDayWithDataStore:_dataStore];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"MidDayToPostDay"])
    {
        // Get reference to the destination view controller
        PostDayViewController *postDayViewController = [segue destinationViewController];
        
        // Pass dataStore to the view controller
        [postDayViewController setDataStore:_dataStore];
    }
    
    [_midDayView releaseAnimationForWeather:_currentWeather];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
