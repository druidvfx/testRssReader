//
//  News.h
//  testRssReader
//
//  Created by Alexey Volkov on 28.09.16.
//  Copyright © 2016 Alexey Volkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RssParse.h"
#import "ImageLinkParse.h"

@protocol NewsDelegate

@required
-(void)newsReloadComplite:(NSInteger)newsCount;	// сообщает о завершении парсинга rssXML

@end


@interface News : NSObject <RssParseDelegate, ImageLinkParseDelegate>
{
	RssParse *my_rssParse;
	ImageLinkParse *my_imageLinkParse;
	
	NSUInteger currentCompliteImageNews;	// количество загруженных с картинками новостей
	NSUInteger overallRssNews;	// сколько новостей всего в массиве
	
	int _maxNewsImageCount;
	
	NSMutableArray *feeds;
	
	NSMutableArray *images;
}
@property (nonatomic, assign) id<NewsDelegate>	delegate;

-(id)init;


-(void)reloadNews:(int)maxNewsImageCount;
-(void)getNextNewsImage;


-(NSString*)getTittleNewsID:(int)newsID;
-(NSString*)getLinkNewsID:(int)newsID;
-(NSString*)getImageLinkNewsID:(int)newsID;
-(NSData*)getImageDataNewsID:(int)newsID;

@end
