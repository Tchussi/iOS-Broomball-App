//
//  TeamViewController.h
//  iOS Broomball App
//
//  Created by Broomball Team on 4/23/14.
//  Copyright (c) 2014 Broomball Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamViewController : UIViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *theSearchBar;
@property (strong, nonatomic) IBOutlet UITextView *textView;

@end
