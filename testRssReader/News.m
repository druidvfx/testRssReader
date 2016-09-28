//
//  News.m
//  testRssReader
//
//  Created by Alexey Volkov on 28.09.16.
//  Copyright © 2016 Alexey Volkov. All rights reserved.
//

#import "News.h"
#import <UIKit/UIKit.h>

@implementation News

@synthesize delegate;


-(id)init
{
	self = [super init];
	if (self != nil)
	{
		delegate = (id<NewsDelegate>)self;
		
		my_rssParse = [[RssParse alloc] init];
		my_rssParse.delegate = self;
		
		my_imageLinkParse = [[ImageLinkParse alloc] init];
		my_imageLinkParse.delegate = self;
		
		images = [[NSMutableArray alloc] init];
	}
	return self;
}

// создать массив новостей и проинитить maxNewsImageCount картинок
-(void)reloadNews:(int)maxNewsImageCount
{
	_maxNewsImageCount = maxNewsImageCount;
	[my_rssParse parseRssLink:@"http://4pda.ru/feed/"];
}

// получить в массив следующю картинку новости
-(void)getNextNewsImage
{
	if (_maxNewsImageCount < overallRssNews)
	{
		_maxNewsImageCount+=3;
		if (_maxNewsImageCount > overallRssNews)
		{
			_maxNewsImageCount = overallRssNews;
		}
		[self startImageLinkParse];
	}
}






-(NSString*)getTittleNewsID:(int)newsID
{
	if (newsID < currentCompliteImageNews)
	{
		NSDictionary *item = [feeds objectAtIndex:newsID];
		return item[@"title"];
	}
	return nil;
}

-(NSString*)getLinkNewsID:(int)newsID
{
	if (newsID < currentCompliteImageNews)
	{
		NSDictionary *item = [feeds objectAtIndex:newsID];
		return item[@"link"];
	}
	return nil;
}

-(NSString*)getImageLinkNewsID:(int)newsID
{
	if (newsID < currentCompliteImageNews)
	{
		NSDictionary *item = [feeds objectAtIndex:newsID];
		return item[@"imageLink"];
	}
	return nil;
}

-(NSData*)getImageDataNewsID:(int)newsID
{
	if (newsID < currentCompliteImageNews)
	{
		return [images objectAtIndex:newsID];
	}
	return nil;
}















-(void)startImageLinkParse
{
	if (currentCompliteImageNews < _maxNewsImageCount && currentCompliteImageNews<overallRssNews)
	{
		// вызываем парсинг imadgeLink
		NSDictionary* item = [feeds objectAtIndex:currentCompliteImageNews];
		NSString *newsLink = item[@"link"];
		[my_imageLinkParse getImageLink:newsLink];
	}
	else
	{
		[delegate newsReloadComplite:currentCompliteImageNews];
	}
	
}


// получили RssXML
-(void)rssXMLParseComplite:(NSMutableArray*)_feeds
{
	if (_feeds != nil)
	{
		if (feeds != nil)
		{
			NSString *old = [feeds objectAtIndex:0][@"title"];
			NSString *new = [_feeds objectAtIndex:0][@"title"];
			if ([old isEqualToString:new])
			{
				[delegate newsReloadComplite:currentCompliteImageNews];
				return;
			}
		}
		feeds = [[NSMutableArray alloc] initWithArray:_feeds];
		overallRssNews = feeds.count;
		currentCompliteImageNews = 0;
		
		// вызываем парсинг линков картинок
		[self startImageLinkParse];
	}
}


-(void)imageLinkParseComplite:(NSString*)imageLink
{
	if (imageLink != nil)
	{
		NSMutableDictionary* item = [feeds objectAtIndex:currentCompliteImageNews];
		[item setObject:imageLink forKey:@"imageLink"];
		
		[self loadImage:imageLink];
		
		currentCompliteImageNews++;
		[self startImageLinkParse];
	}
}

-(void)loadImage:(NSString*)link
{
	NSURL *aURL = [NSURL URLWithString:link];
	NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
	UIImage *image = [UIImage imageWithData:data];
	
	// ресайз
	CGSize size= CGSizeMake(64, 64);
	UIGraphicsBeginImageContext(size);
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSData *newImageData = UIImagePNGRepresentation(destImage);
	[images addObject:newImageData];
}





@end
