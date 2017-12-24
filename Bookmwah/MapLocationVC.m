//
//  MapLocationVC.m
//  Bookmwah
//
//  Created by admin on 19/05/16.
//  Copyright © 2016 Mahesh Kumar Dhakad. All rights reserved.
//

#import "MapLocationVC.h"
#import "MyLocation.h"

#define METERS_PER_MILE 2000

@interface MapLocationVC ()

@end

@implementation MapLocationVC

@synthesize myMapView, m_bAllMap, arrAllData, mapData;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    myMapView.delegate=self;
    [myMapView setShowsUserLocation:true];
    
    CLLocationCoordinate2D zoomLocation;
    
    if (!m_bAllMap) {
        if (![[mapData valueForKey:@"pro_lat"] isKindOfClass:[NSNull class]]) {
            zoomLocation.latitude = [[mapData valueForKey:@"pro_lat"] doubleValue];
            zoomLocation.longitude= [[mapData valueForKey:@"pro_long"] doubleValue];
            
            MyLocation *annotation = [[MyLocation alloc] initWithName:[mapData valueForKey:@"pro_addr"] address:@"" coordinate:zoomLocation] ;
            [self.myMapView addAnnotation:annotation];
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, METERS_PER_MILE, METERS_PER_MILE);
            MKCoordinateRegion adjustedRegion = [self.myMapView regionThatFits:viewRegion];
            [self.myMapView setRegion:adjustedRegion animated:YES];
        }
    } else {
        for (int i = 0; i < self.arrAllData.count; i++) {
            
            NSDictionary *item = [self.arrAllData objectAtIndex:i];
            
            NSString * str = [item valueForKey:@"pro_lat"];
            if ([str isKindOfClass:[NSNull class]]) {
                continue;
            }
            
            zoomLocation.latitude = [[item valueForKey:@"pro_lat"] doubleValue];
            zoomLocation.longitude= [[item valueForKey:@"pro_long"] doubleValue];
            
            MyLocation *annotation = [[MyLocation alloc] initWithName:[item valueForKey:@"pro_name"] address:@"" coordinate:zoomLocation] ;
            [self.myMapView addAnnotation:annotation];
        }
    }
    

    
}

#pragma mark -
#pragma mark MKMapView delegate
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
   
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[MyLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [myMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"map"];//here we use a nice image instead of the default pins
        
        return annotationView;
    }
    
    return nil;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
