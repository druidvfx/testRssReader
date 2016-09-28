//
//  DetailViewController.h
//  testRssReader
//
//  Created by Alexey Volkov on 28.09.16.
//  Copyright © 2016 Alexey Volkov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
