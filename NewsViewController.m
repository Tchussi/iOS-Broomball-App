//
//  NewsViewController.m
//  iOS Broomball App
//
//  Created by Broomball Team on 4/23/14.
//  Copyright (c) 2014 Broomball Team. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //Inheret viewDidLoad method
    [super viewDidLoad];
    
    //Pulls from Broomball News Feed and converts it to NSData type
    //Using Synchronous Requests Apple Recommends ASynchronous
    NSString *fullURL = @"http://broomball.mtu.edu/api/news/key/e5215493bf189ea19a3a7c12e56e1fe582a2b895";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
    
    
    //Converting NSData response to a Dictionary
    NSError *JSONerror;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:0 error:&JSONerror];
    
    //NSArray *bodyArray = [json objectForKey:@"body"];
    //sets up the formatting for the Newsfeed
    NSString *body = @"<h2>Broomball News Feed</h2>";
    NSString *h3start = @"<h3>";//header type for titles
    NSString *h3end = @"</h3>";
    NSString *temp = @"<em>Last Updated: ";//displays time the newsfeed was updated on the device and italisizes it
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM, dd HH:mm:ss"];//sets date format to "Month, day hour:minute:second"
    
    dateString = [formatter stringFromDate:[NSDate date]];//sets the time as a string
    body = [body stringByAppendingString:temp];
    body = [body stringByAppendingString:dateString];
    temp = @"</em>";//end italiscies
    body = [body stringByAppendingString:temp];
    
    
    for(NSDictionary *bodyDict in json)
    {
        NSString *titleTemp = [bodyDict objectForKey:@"subject"];//gets the subject of the post
        body = [body stringByAppendingString:h3start];
        body = [body stringByAppendingString:titleTemp];//adds the subject as a header
        body = [body stringByAppendingString:h3end];
        
        NSString *bodyTemp = [bodyDict objectForKey:@"body"];//gets the body of the post
        body = [body stringByAppendingString:bodyTemp];//adds body
        
    }
    [_viewWeb loadHTMLString:body baseURL:url];//sets webview
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
