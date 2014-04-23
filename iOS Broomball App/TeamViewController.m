//
//  TeamViewController.m
//  iOS Broomball App
//
//  Created by Broomball Team on 4/23/14.
//  Copyright (c) 2014 Broomball Team. All rights reserved.
//

#import "TeamViewController.h"

@interface TeamViewController ()

@end

@implementation TeamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize theSearchBar;

- (void)viewDidLoad
{
    //Inheret viewDidLoad method
    [super viewDidLoad];
    theSearchBar.delegate = self;
    [_textView setUserInteractionEnabled:TRUE];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UISearchBarDelegate Methods

//Check this Method
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _textView.text = @"";
    //Runs when searchbar is clicked and gets current text
    NSString *resultFull = searchBar.text;
    NSString *result = [resultFull stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    //Pulls from Broomball News Feed and converts it to NSData type
    //Using Synchronous Requests Apple Recommends ASynchronous
    NSString *fullURL = @"http://broomball.mtu.edu/api/team/search/";
    fullURL = [fullURL stringByAppendingString:result];
    fullURL = [fullURL stringByAppendingString:@"/key/e5215493bf189ea19a3a7c12e56e1fe582a2b895"];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    NSData *response = [NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
    
    //Converting NSData response to a Dictionary
    NSError *JSONerror;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:response options:0 error:&JSONerror];
    
    //Parse out id strings from json object
    NSMutableArray *idStrings = [[NSMutableArray alloc] init];
    
    for(NSDictionary *idDict in json)
    {
        NSString *id = [json objectForKey:@"id"];
        [idStrings addObject:id];
    }
    
    //Iterates through ids
    for(NSString *ids in idStrings)
    {
        //Pulls from Broomball News Feed and converts it to NSData type
        //Using Synchronous Requests Apple Recommends ASynchronous
        fullURL = @"http://broomball.mtu.edu/api/team/id/";
        fullURL = [fullURL stringByAppendingString:ids];
        fullURL = [fullURL stringByAppendingString:@"/key/e5215493bf189ea19a3a7c12e56e1fe582a2b895"];
        url = [NSURL URLWithString:fullURL];
        requestObj = [NSURLRequest requestWithURL:url];
        response = [NSURLConnection sendSynchronousRequest:requestObj returningResponse:nil error:nil];
        
        //Converting NSData response to a Dictionary
        json = [NSJSONSerialization JSONObjectWithData:response options:0 error:&JSONerror];
        
        //Parse out info name, info season_id, roster display_name
        [self populateText:json];
    }
    
}

//Populates Text based on JSON object
- (void)populateText:(NSDictionary *) dict
{
    
    //Parse out info name, info season_id, roster display_name
    NSDictionary *info = [dict objectForKey:@"info"];
    NSDictionary *roster = [dict objectForKey:@"roster"];
    NSString *nameString = [info objectForKey:@"name"];
    NSString *yearString = [info objectForKey:@"season_id"];
    id captainString = [info objectForKey:@"captain_player_id"];
    
    //Appends with Spaces name season_id
    nameString = [nameString stringByAppendingString:@"    Year: "];
    nameString = [nameString stringByAppendingString:yearString];
    _textView.text = [_textView.text stringByAppendingString:@"\n"];
    _textView.text = [_textView.text stringByAppendingString:nameString];
    _textView.text = [_textView.text stringByAppendingString:@"\n"];
    
    //Appends the display_name to the current text of textView
    NSEnumerator *display = [roster keyEnumerator];
    id key;
    while((key = [display nextObject]))
    {
        NSDictionary *temp = [roster objectForKey:key];
        NSString *playerName = [temp objectForKey:@"display_name"];
        _textView.text = [_textView.text stringByAppendingString:playerName];
        if(key == captainString)
        {
            _textView.text = [_textView.text stringByAppendingString:@"  (Cpt.)"];
        }
        //Check for if is Captain or Not to add Captain tag
        _textView.text = [_textView.text stringByAppendingString:@"\n"];
    }
    
    
}

//Hides Keyboard for textView
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}



@end
