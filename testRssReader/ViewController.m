//
//  ViewController.m
//  testRssReader
//
//  Created by Alexey Volkov on 28.09.16.
//  Copyright © 2016 Alexey Volkov. All rights reserved.
//

#import "ViewController.h"



@implementation ViewController

@dynamic tableView;


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	my_news = [[News alloc] init];
	my_news.delegate = self;
	
	_newsLoaded = 0;
	
	[my_news reloadNews:10];
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refresh)
			 forControlEvents:UIControlEventValueChanged];
	self.refreshControl = refreshControl;
	

}
#pragma mark - Table View

-(void)refresh
{
	// do something here to refresh.
	[my_news reloadNews:10];
}

// количество секций
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// кооличество полей в секции
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _newsLoaded;
	
}


// запрашивает  cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == _newsLoaded-1)
	{
		[my_news getNextNewsImage];
	}
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	cell.textLabel.text = [my_news getTittleNewsID:indexPath.row];
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	cell.textLabel.minimumScaleFactor = 0.75f;
	
	NSData *data = [my_news getImageDataNewsID:indexPath.row];
	cell.imageView.image = [UIImage imageWithData:data];

    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
	{
		
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSString *string = [my_news getLinkNewsID:indexPath.row];
        [[segue destinationViewController] setUrl:string];
        
    }
}



-(void)newsReloadComplite:(NSInteger)newsCount
{
	NSLog(@"%d",(int)newsCount);
	_newsLoaded = newsCount;
	[self.tableView reloadData];
	[self.refreshControl endRefreshing];
}


@end
