//
//  ViewController.h
//  testRssReader
//
//  Created by Alexey Volkov on 28.09.16.
//  Copyright © 2016 Alexey Volkov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "News.h"

@interface ViewController : UITableViewController <NSXMLParserDelegate, NewsDelegate>
{
	News *my_news;
	
	int _newsLoaded;

}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

-(void)newsReloadComplite:(NSInteger)newsCount;

@end
